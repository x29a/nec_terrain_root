package com.terrain.terroot;

import android.content.Context;
import android.content.res.AssetManager;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;


public class MainActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView textView = (TextView) findViewById(R.id.textView);
        textView.setMovementMethod(new ScrollingMovementMethod());

        //startRooting(findViewById(android.R.id.content));
    }

    public void startRooting(View view) {
        log("terrooting...");
        tempRoot(view);
    }

    public void tempRoot(View view)
    {
        // copy files to writable destination
        log("copy assets to fon");
        copyAssetFile("busybox", getApplicationContext());
        copyAssetFile("setup_busybox.sh", getApplicationContext());
        copyAssetFile("su", getApplicationContext());
        copyAssetFile("run_root_shell", getApplicationContext());
        copyAssetFile("superuser.apk", getApplicationContext());
        copyAssetFile("runner.sh", getApplicationContext());
        copyAssetFile("deploy.sh", getApplicationContext());
        log("copy finished");

        try
        {
            String dataFolder = getApplicationContext().getFilesDir().toString();

            Process nativeApp = Runtime.getRuntime().exec(dataFolder + "//runner.sh");

            BufferedReader reader = new BufferedReader(new InputStreamReader(nativeApp.getInputStream()));
            int read;
            char[] buffer = new char[4096];
            StringBuffer output = new StringBuffer();
            while ((read = reader.read(buffer)) > 0) {
                output.append(buffer, 0, read);
            }
            reader.close();

            // Waits for the command to finish.
            nativeApp.waitFor();

            log(output.toString());
        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
        catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

    }

    private static void copyAssetFile(String filename, Context context) {
        try {
            String finalPath = context.getFilesDir().toString() + File.separator + filename;

            InputStream in = context.getAssets().open(filename);
            FileOutputStream out = new FileOutputStream(finalPath);
            int read;
            byte[] buffer = new byte[4096];
            while ((read = in.read(buffer)) > 0) {
                out.write(buffer, 0, read);
            }
            out.close();
            in.close();

            // set executable bit
            File file = new File(finalPath);
            file.setExecutable(true, false);

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }



    public void log(String logMessage) {

        TextView textView = (TextView) findViewById(R.id.textView);
        textView.append(logMessage+"\n");
    }
}
