package com.emotiv.cortex;

import android.app.Activity;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * CortexPlugin
 */
public class CortexMethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

    private final CortexManager manager;

    CortexMethodCallHandlerImpl(CortexManager manager) {
        this.manager = manager;
    }

    @Nullable
    private Activity activity;

    public void setActivity(@Nullable Activity activity) {
        this.activity = activity;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "startCortex":
                final boolean error = manager.startCortex();
                result.success(error);
                break;
            case "sendRequest":
                final String command = call.argument("command");
                if(manager.sendJsonRequest(command)) {
                    result.success(null);
                }
                else {
                    result.error("CortexClient error",
                            "CortexClient is not created", null);
                }
                break;
            case "authenticate":
                final String clientId = call.argument("clientId");
                manager.requestAuthenticate(activity, clientId,
                        result::success,
                        (String errorCode, String errorDescription) -> result.error(
                                errorCode,
                                errorDescription,
                                null));
                break;
            default:
                result.notImplemented();
        }
    }
}
