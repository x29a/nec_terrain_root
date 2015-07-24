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
import android.view.Window;
import android.view.WindowManager;
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
        // Remove title bar
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        // Remove notification bar
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView textView = (TextView) findViewById(R.id.textView);
        textView.setMovementMethod(new ScrollingMovementMethod());

        //startRooting(findViewById(android.R.id.content));
    }

    public void copyAssets(View view) {
        // copy files to writable destination
        log("copy assets to fon");
        try {
            String [] list = getApplicationContext().getAssets().list("");
            if (list.length > 0) {
                for (String file : list) {
                    copyAssetFile(file, getApplicationContext());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        log("copy finished");
        log("deploy assets start");
        executeCommand("deploy.sh");
        log("deploy assets finished");
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

        }
        catch(FileNotFoundException e)
        {
            // ignore file not found
        }
        catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    public void backup(View view)
    {
        log("backup start");
        executeCommand("backup.sh");
        log("backup finished");
    }

    public void reboot(View view)
    {
        log("reboot start");
        executeCommand("reboot.sh");
        log("reboot finished");
    }

    public void modGPT(View view)
    {
        log("modGPT start");
        executeCommand("modGPT.sh");
        log("modGPT finished");
    }

    public void recovery_boot(View view)
    {
        log("recoveryboot start");
        executeCommand("recovery_boot.sh");
        log("recoveryboot finished");
    }

    public void su(View view)
    {
        log("su start");
        executeCommand("preparesu.sh");
        log("su finished");
    }

    public void kas_recovery(View view)
    {
        log("kas.recovery start");
        executeCommand("kas_recovery.sh");
        log("kas.recovery finished");
    }

    public void kas_boot(View view)
    {
        log("kas.boot start");
        executeCommand("kas_boot.sh");
        log("kas.boot finished");
    }

    public void executeCommand(String commandName)
    {
        try
        {
            String dataFolder = getApplicationContext().getFilesDir().toString();

            Process nativeApp = Runtime.getRuntime().exec(dataFolder + "//" + commandName);

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
            log("error: " + commandName);
        }
        catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }

    public void log(String logMessage) {

        TextView textView = (TextView) findViewById(R.id.textView);
        textView.append(logMessage+"\n");
    }
}
