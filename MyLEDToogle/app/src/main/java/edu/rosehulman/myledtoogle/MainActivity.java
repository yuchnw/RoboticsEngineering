package edu.rosehulman.myledtoogle;

import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import edu.rosehulman.me435.AccessoryActivity;
import edu.rosehulman.me435.TextToSpeechHelper;

public class MainActivity extends AccessoryActivity {

    private TextToSpeechHelper mTts;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    protected void onStart(){
        super.onStart();
        mTts = new TextToSpeechHelper(this);
    }

    @Override
    protected void onStop(){
        super.onStop();
        mTts.shutdown();
    }

    public void pressOn(View view) {
        Toast.makeText(this,"LED ON",Toast.LENGTH_SHORT).show();
        sendCommand("ON");
    }

    public void pressOff(View view) {
        Toast.makeText(this,"LED OFF",Toast.LENGTH_SHORT).show();
        sendCommand("OFF");
    }

    @Override
    public void onCommandReceived(String receivedCommand){
        super.onCommandReceived(receivedCommand);
        Toast.makeText(this,"Received: " + receivedCommand,Toast.LENGTH_SHORT).show();

        if(receivedCommand.toLowerCase().contains("left")){
            findViewById(android.R.id.content).setBackgroundColor(Color.GREEN);
            mTts.speak(receivedCommand);
        }
        else if(receivedCommand.toLowerCase().contains("right")){
            findViewById(android.R.id.content).setBackgroundColor(Color.BLACK);
            mTts.speak(receivedCommand);
        }
    }
}
