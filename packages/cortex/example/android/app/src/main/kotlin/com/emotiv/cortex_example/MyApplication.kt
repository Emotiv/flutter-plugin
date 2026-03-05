package com.emotiv.cortex_example

import android.app.Application
import android.util.Log
import com.emotiv.CortexLib
import com.emotiv.EmotivLibraryLoader

class MyApplication : Application() {
    override fun onCreate() {
        Log.e("app", "run my application")
        val loader = EmotivLibraryLoader(this)
        loader.load()
        super.onCreate()
    }

    override fun onTerminate() {
        super.onTerminate()
        CortexLib.stop()
    }
}
