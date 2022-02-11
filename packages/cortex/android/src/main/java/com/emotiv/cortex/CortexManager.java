package com.emotiv.cortex;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;

import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Consumer;

import com.emotiv.CortexClient;
import com.emotiv.CortexLib;
import com.emotiv.CortexLibInterface;
import com.emotiv.ResponseHandler;

import org.json.JSONObject;

import io.flutter.plugin.common.PluginRegistry;

public class CortexManager implements PluginRegistry.ActivityResultListener, ResponseHandler, CortexLibInterface {

    public enum EventType {
        ResponseEvent,
        WarningEvent,
        DataStreamEvent
    }

    static final String LOG_TAG = "CortexManager";
    static final int AUTHENTICATE_HANDLE_CODE = 100;
    private final HashMap<EventType, List<CortexEventListener>> listeners = new HashMap<>();
    private boolean ongoing = false;

    @Nullable
    private ActivityResultSuccessCallback successCallback;

    @Nullable
    private CortexClient mCortexClient;

    @FunctionalInterface
    interface ActivityResultSuccessCallback {
        void onSuccess(String result);
    }

    @FunctionalInterface
    interface ErrorCallback {
        void onError(String errorCode, String errorDescription);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == AUTHENTICATE_HANDLE_CODE) {
            String code = "unknown";
            if(mCortexClient != null)
                code = mCortexClient.getAuthenticationCode(requestCode, data);

            if(successCallback != null)
                successCallback.onSuccess(code);
            ongoing = false;
            return true;
        }
        return false;
    }

    @Override
    public void onCortexStarted() {
        Log.d(LOG_TAG, "Cortex lib started");
        if (mCortexClient == null) {
            mCortexClient = new CortexClient();
            mCortexClient.registerResponseHandler(this);
        }
    }

    @Override
    public void processResponse(String s) {
        //Log.d(LOG_TAG, "Cortex message " + s);
        try {
            JSONObject jsonObj = new JSONObject(s);
            Consumer<CortexEventListener> method = (n) -> n.onEventUpdated(s);
            // received warning message in response to a RPC request
            if (jsonObj.has("warning")) {
                List<CortexEventListener> values = listeners.get(EventType.WarningEvent);
                if (values != null) {
                    values.forEach(method);
                }
            }
            // received data from a data stream
            else if (jsonObj.has("sid")) {
                List<CortexEventListener> values = listeners.get(EventType.DataStreamEvent);
                if (values != null) {
                    values.forEach(method);
                }
            } else {
                List<CortexEventListener> values = listeners.get(EventType.ResponseEvent);
                if (values != null) {
                    values.forEach(method);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void registerListener(CortexEventListener item, EventType eventType) {
        listeners.putIfAbsent(eventType, new ArrayList<>());
        listeners.get(eventType).add(item);
    }

    public void unregisterListener(CortexEventListener item) {
        for (Map.Entry<EventType, List<CortexEventListener>> ee : listeners.entrySet()) {
            List<CortexEventListener> values = ee.getValue();
            values.remove(item);
        }
    }

    boolean startCortex() {
        return CortexLib.start(this);
    }

    boolean sendJsonRequest(String request) {
        if (mCortexClient == null)
            return false;
        mCortexClient.sendRequest(request);
        return true;
    }

    void requestAuthenticate(Activity activity,
                             String clientID,
                             ActivityResultSuccessCallback successCallback,
                             ErrorCallback errorCallback) {
        if (ongoing) {
            errorCallback.onError(
                    "CortexManager.Authenticate",
                    "A request for authenticate is already running, please wait for it to finish before doing another request.");
            return;
        }

        if (activity == null) {
            Log.d(LOG_TAG, "Unable to detect current Activity.");

            errorCallback.onError(
                    "CortexManager.Authenticate",
                    "Unable to detect current Android Activity.");
            return;
        }

        if (mCortexClient == null) {
            Log.d(LOG_TAG, "Unable to detect current CortexClient.");

            errorCallback.onError(
                    "CortexManager.Authenticate",
                    "Unable to detect current CortexClient.");
            return;
        }

        this.successCallback = successCallback;

        mCortexClient.authenticate(activity, clientID, AUTHENTICATE_HANDLE_CODE);
        ongoing = true;
    }
}
