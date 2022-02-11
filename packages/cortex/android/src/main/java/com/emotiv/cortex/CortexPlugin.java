package com.emotiv.cortex;

import android.app.Activity;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

public final class CortexPlugin implements FlutterPlugin, ActivityAware {

    private MethodChannel methodChannel;
    private static final String RESPONSE_EVENT_CHANNEL_NAME = "dev.emotiv.cortex/response";
    private static final String WARNING_EVENT_CHANNEL_NAME = "dev.emotiv.cortex/warning";
    private static final String DATA_STREAM_EVENT_CHANNEL_NAME = "dev.emotiv.cortex/dataStream";
    private static final String CORTEX_METHOD_CHANNEL_NAME = "dev.emotiv.cortex/methods";

    private EventChannel responseChannel;
    private EventChannel warningChannel;
    private EventChannel dataStreamChannel;

    private final CortexManager manager;

    @Nullable
    private ActivityPluginBinding pluginBinding;

    @Nullable
    private CortexMethodCallHandlerImpl methodCallHandler;

    public CortexPlugin() {
        this.manager = new CortexManager();
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        startListening(binding.getBinaryMessenger());
        setupEventChannels(binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        stopListening();
        teardownEventChannels();
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        startListeningToActivity(binding.getActivity());
        this.pluginBinding = binding;
        registerListeners();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        stopListeningToActivity();
        deregisterListeners();
    }

    private void setupEventChannels(BinaryMessenger messenger) {
        responseChannel = new EventChannel(messenger, RESPONSE_EVENT_CHANNEL_NAME);
        final StreamHandlerImpl responseStreamHandler = new StreamHandlerImpl(manager, CortexManager.EventType.ResponseEvent);
        responseChannel.setStreamHandler(responseStreamHandler);

        warningChannel = new EventChannel(messenger, WARNING_EVENT_CHANNEL_NAME);
        final StreamHandlerImpl warningStreamHandler = new StreamHandlerImpl(manager, CortexManager.EventType.WarningEvent);
        warningChannel.setStreamHandler(warningStreamHandler);

        dataStreamChannel = new EventChannel(messenger, DATA_STREAM_EVENT_CHANNEL_NAME);
        final StreamHandlerImpl dataStreamStreamHandler = new StreamHandlerImpl(manager, CortexManager.EventType.DataStreamEvent);
        dataStreamChannel.setStreamHandler(dataStreamStreamHandler);
    }

    private void teardownEventChannels() {
        responseChannel.setStreamHandler(null);
        warningChannel.setStreamHandler(null);
        dataStreamChannel.setStreamHandler(null);
    }

    private void startListening(BinaryMessenger messenger) {
        methodChannel = new MethodChannel( messenger, CORTEX_METHOD_CHANNEL_NAME);
        methodCallHandler = new CortexMethodCallHandlerImpl(this.manager);
        methodChannel.setMethodCallHandler(methodCallHandler);
    }

    private void stopListening() {
        methodChannel.setMethodCallHandler(null);
        methodChannel = null;
        methodCallHandler = null;
    }

    private void startListeningToActivity(Activity activity) {
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(activity);
        }
    }

    private void stopListeningToActivity() {
        if (methodCallHandler != null) {
            methodCallHandler.setActivity(null);
        }
    }

    private void registerListeners() {
        if (pluginBinding != null) {
            this.pluginBinding.addActivityResultListener(this.manager);
        }
    }

    private void deregisterListeners() {
        if (this.pluginBinding != null) {
            this.pluginBinding.removeActivityResultListener(this.manager);
        }
    }
}
