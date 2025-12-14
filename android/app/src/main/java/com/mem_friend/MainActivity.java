package com.mem_friend;

import android.content.res.AssetManager;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import com.viface.vifacecore.FaceCallback;
import com.viface.vifacecore.FaceDetectCallback;
import com.viface.vifacecore.FaceLibrary;
import com.viface.vifacecore.FaceUnrecognizedCallback;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {

    private static final String METHOD_CHANNEL = "vi_face_core/methods";
    private static final String EVENT_RECOGNIZED = "vi_face_core/events/recognized";
    private static final String EVENT_UNRECOGNIZED = "vi_face_core/events/unrecognized";
    private static final String EVENT_DETECT = "vi_face_core/events/detect";

    private final FaceLibrary faceLibrary = new FaceLibrary();
    private final ExecutorService backgroundExecutor = Executors.newSingleThreadExecutor();
    private final Handler mainHandler = new Handler(Looper.getMainLooper());

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        final MethodChannel methodChannel = new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                METHOD_CHANNEL
        );

        methodChannel.setMethodCallHandler(this::onMethodCall);

    }

    private void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        backgroundExecutor.execute(() -> {
            try {
                switch (call.method) {
                    case "loadAIModel": {
                        boolean detectGpu = getBooleanArg(call, "detect_gpu");
                        boolean recognitionGpu = getBooleanArg(call, "recognition_gpu");
                        AssetManager mgr = getAssets();
                        boolean ok = faceLibrary.loadAIModel(mgr, detectGpu, recognitionGpu);
                        mainHandler.post(() -> result.success(ok));
                        break;
                    }
                    case "loadDatabase": {
                        String filePath = getStringArg(call, "filePath");
                        boolean ok = faceLibrary.loadDatabase(filePath);
                        mainHandler.post(() -> result.success(ok));
                        break;
                    }
                    case "faceRecognition": {
                        @SuppressWarnings("unchecked")
                        List bitmapList = (List) call.argument("bitmap");
                        int width = getIntArg(call, "width");
                        int height = getIntArg(call, "height");
                        int[] pixels = listLongToIntArray(bitmapList);
                        Object[] results = faceLibrary.faceRecognition(pixels, width, height);
                        Map<String, Object> resultMap = new HashMap<>();
                        resultMap.put("distance", (float)results[0]);
                        resultMap.put("id", (int)results[1]);
                        mainHandler.post(() -> result.success(resultMap));
                        break;
                    }
                    case "faceToVector": {
                        @SuppressWarnings("unchecked")
                        List bitmapList = (List) call.argument("bitmap");
                        int width = getIntArg(call, "width");
                        int height = getIntArg(call, "height");
                        int[] pixels = listLongToIntArray(bitmapList);
                        float[] vector = faceLibrary.faceToVector(pixels, width, height);
                        mainHandler.post(() -> result.success(vector));
                        break;
                    }
                    case "buildVectorData": {
                        @SuppressWarnings("unchecked")
                        List<Integer> faceIdsList = (List<Integer>) call.argument("faceIds");
                        int[] faceIds = listToIntArray(faceIdsList);
                        @SuppressWarnings("unchecked")
                        List<List<Double>> faceVectorsList = (List<List<Double>>) call.argument("faceVectors");
                        float[][] faceVectors = listListDoubleToFloat2D(faceVectorsList);
                        String folderSaveTree = getStringArg(call, "folderSaveTree");
                        String result_path = faceLibrary.buildVectorData(faceIds, faceVectors, folderSaveTree);
                        mainHandler.post(() -> result.success(result_path));
                        break;
                    }
                    case "faceRecognitionConfig": {
                        int minDistanceFace = getIntArg(call, "minDistanceFace");
                        int maxDistanceFace = getIntArg(call, "maxDistanceFace");
                        int maxAngleFace = getIntArg(call, "maxAngleFace");
                        double threshold = getDoubleArg(call, "faceRecognitionThreshold");
                        boolean resizeOption = getBooleanArg(call, "resize_option");
                        boolean ok = faceLibrary.faceRecognitionConfig(
                                minDistanceFace,
                                maxDistanceFace,
                                maxAngleFace,
                                (float) threshold,
                                resizeOption
                        );
                        mainHandler.post(() -> result.success(ok));
                        break;
                    }
                    default:
                        mainHandler.post(result::notImplemented);
                }
            } catch (Throwable t) {
                t.printStackTrace();
                mainHandler.post(() -> result.error("error", t.getMessage(), null));
            }
        });
    }

    private static boolean getBooleanArg(MethodCall call, String key) {
        Boolean v = call.argument(key);
        return v != null && v;
    }

    private static int getIntArg(MethodCall call, String key) {
        Integer v = call.argument(key);
        return v != null ? v : 0;
    }

    private static double getDoubleArg(MethodCall call, String key) {
        Double v = call.argument(key);
        return v != null ? v : 0.0;
    }

    private static String getStringArg(MethodCall call, String key) {
        String v = call.argument(key);
        return v != null ? v : "";
    }

    private static int[] listToIntArray(List<Integer> list) {
        if (list == null) return new int[0];
        int[] arr = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
            Integer val = list.get(i).intValue();
            arr[i] = val != null ? val : 0;
        }
        return arr;
    }
    private static int[] listLongToIntArray(List list) {
        if (list == null) return new int[0];
        int[] arr = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
            Integer val = ((Long)list.get(i)).intValue();
            arr[i] = val;
        }
        return arr;
    }

    private static float[][] listListDoubleToFloat2D(List<List<Double>> list) {
        if (list == null) return new float[0][0];
        int outer = list.size();
        float[][] result = new float[outer][];
        for (int i = 0; i < outer; i++) {
            List<Double> innerList = list.get(i);
            if (innerList == null) {
                result[i] = new float[0];
                continue;
            }
            int inner = innerList.size();
            float[] row = new float[inner];
            for (int j = 0; j < inner; j++) {
                Double v = innerList.get(j);
                row[j] = v != null ? v.floatValue() : 0f;
            }
            result[i] = row;
        }
        return result;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        backgroundExecutor.shutdownNow();
    }
}

