package edu.rosehulman.simplefsm;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

public class MainActivity extends Activity {

  public enum State{
    READY, RUNNING_A_SCRIPT, SEEKING_HOME, SEEKING_SOMEWHERE, SUCCESS, MAGIC_CARPET
  }

  private State mState = State.READY;

  private TextView mCurrentStateTextView, mStateTimeTextView;
  private long mStateStartTime;

  private Handler mCommandHandler = new Handler();
  private Timer mTimer;
  private static final int LOOP_INTERVAL_MS = 100;
  
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    
    mCurrentStateTextView = (TextView) findViewById(R.id.current_state_textview);
    mStateTimeTextView = (TextView) findViewById(R.id.state_time_textview);
    setState(State.READY);
  }

  @Override
  protected void onStart() {
    super.onStart();
    mTimer = new Timer();
    mTimer.scheduleAtFixedRate(new TimerTask() {
      @Override
      public void run() {
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            loop();
          }
        });
      }
    }, 0, LOOP_INTERVAL_MS);
  }

  private void loop(){
    //Update the UI to show the time in the current state.
    mStateTimeTextView.setText("" + (System.currentTimeMillis() - mStateStartTime)/1000);

    switch(mState){
      case SEEKING_HOME:
        if(System.currentTimeMillis() - mStateStartTime > 6000){
          setState(State.READY);
        }
        break;
      case SEEKING_SOMEWHERE:
        if(System.currentTimeMillis() - mStateStartTime > 3000){
          setState(State.SUCCESS);
        }
        break;
      default:
        break;
    }
  }

  @Override
  protected void onStop() {
    super.onStop();
    mTimer.cancel();
    mTimer = null;
  }

  private void setState(State newState){
    //Opportunity to do stuff when a new state is set.

    //Write down (in a variable) the current time
    mStateStartTime = System.currentTimeMillis();

    //Update the UI with the name of the current state
    mCurrentStateTextView.setText(newState.name());

    switch(newState){
      case READY:
        break;
      case RUNNING_A_SCRIPT:
        runScript();
        break;
      case SEEKING_HOME:
        break;
      case SUCCESS:
        break;
      case SEEKING_SOMEWHERE:
        break;
      case MAGIC_CARPET:
        magicScript();
        break;
      default:
        break;
    }
    mState = newState;
  }

  private void runScript(){
    Toast.makeText(MainActivity.this,"Script step 0",Toast.LENGTH_SHORT).show();
    mCommandHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(MainActivity.this,"Script step 1",Toast.LENGTH_SHORT).show();
      }
    },2000);
    mCommandHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(MainActivity.this,"Script step 2",Toast.LENGTH_SHORT).show();
      }
    },4000);
    mCommandHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(MainActivity.this,"Script is done",Toast.LENGTH_SHORT).show();
        if(mState == State.RUNNING_A_SCRIPT){
          setState(State.SEEKING_HOME);
        }
      }
    },5000);
  }

  private void magicScript(){
    Toast.makeText(MainActivity.this,"Magic",Toast.LENGTH_SHORT).show();
    mCommandHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(MainActivity.this,"Carpet",Toast.LENGTH_SHORT).show();
      }
    },2000);
    mCommandHandler.postDelayed(new Runnable() {
      @Override
      public void run() {
        Toast.makeText(MainActivity.this,"Magic Script is done",Toast.LENGTH_SHORT).show();
        if(mState == State.MAGIC_CARPET){
          setState(State.SUCCESS);
        }
      }
    },5000);
  }

  public void handleGo(View view) {
    // TODO: If in the ready state, set the state to Running a script.
    if(mState == State.READY){
      setState(State.RUNNING_A_SCRIPT);
    } else if(mState == State.SEEKING_HOME){
      setState(State.SEEKING_SOMEWHERE);
    }
  }
  
  public void handleReset(View view) {
    Toast.makeText(this, "You pressed Reset", Toast.LENGTH_SHORT).show();
    // TODO: Set the state to Ready.
    if(mState == State.SEEKING_HOME || mState == State.SUCCESS){
      setState(State.READY);
    }
  }
  
  public void handleHitTarget(View view) {
    Toast.makeText(this, "You pressed Hit Target", Toast.LENGTH_SHORT).show();
    // TODO: If in the seeking home state, set the state to Success.
    if(mState == State.SEEKING_HOME){
      setState(State.SUCCESS);
    } else if(mState == State.READY){
      setState(State.MAGIC_CARPET);
    }
  }
}
