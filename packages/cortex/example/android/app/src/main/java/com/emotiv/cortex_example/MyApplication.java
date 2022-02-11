package com.emotiv.cortex_example;

import android.app.Application;
import android.util.Log;

import com.emotiv.CortexLib;
import com.emotiv.EmotivLibraryLoader;

public class MyApplication extends Application {
    @Override
    public void onCreate() {
        Log.e("app", "run my application");
        EmotivLibraryLoader loader = new EmotivLibraryLoader(this);
        loader.load();
        super.onCreate();
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        CortexLib.stop();
    }
}
