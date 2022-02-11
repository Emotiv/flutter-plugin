package com.emotiv.cortex;

import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel;
public class StreamHandlerImpl implements EventChannel.StreamHandler {

    private CortexEventListener cortexEventListener;
    private final CortexManager cortexManager;
    private final CortexManager.EventType type;

    private final Handler uiThreadHandler = new Handler(Looper.getMainLooper());
    StreamHandlerImpl(CortexManager cortexManager, CortexManager.EventType type) {
        this.cortexManager = cortexManager;
        this.type = type;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        cortexEventListener = createCortexEventListener(events);
        cortexManager.registerListener(cortexEventListener, type);
    }

    @Override
    public void onCancel(Object arguments) {
        cortexManager.unregisterListener(cortexEventListener);
    }

    CortexEventListener createCortexEventListener(final EventChannel.EventSink events){
        return (String event) -> uiThreadHandler.post(() -> events.success(event));
    }
}
