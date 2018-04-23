package edu.rosehulman.onegoodgpsreading;

import android.app.Activity;
import android.location.Location;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Timer;
import java.util.TimerTask;

import edu.rosehulman.me435.AccessoryActivity;
import edu.rosehulman.me435.FieldGps;
import edu.rosehulman.me435.FieldGpsListener;
import edu.rosehulman.me435.FieldOrientation;
import edu.rosehulman.me435.FieldOrientationListener;
import edu.rosehulman.me435.NavUtils;

public class OneGoodGpsReadingActivity extends AccessoryActivity implements FieldGpsListener, FieldOrientationListener {
    // Various constants and member variable names.
    private static final String TAG = "OneGoodGps";
    private static final double NO_HEADING_KNOWN = 360.0;
    private TextView mCurrentStateTextView, mStateTimeTextView, mGpsInfoTextView, mSensorOrientationTextView;
    private int mGpsCounter = 0;
    private double mCurrentGpsX, mCurrentGpsY, mCurrentGpsHeading;
    private double mCurrentSensorHeading;
    private Handler mCommandHandler = new Handler();
    private Timer mTimer;
    public static final int LOOP_INTERVAL_MS = 100;
    private FieldGps mFieldGps;
    private FieldOrientation mFieldOrientation;

    public static final int LOWEST_DESIRABLE_DUTY_CYCLE = 150;
    public static final int LEFT_PWM_VALUE_FOR_STRAIGHT = 245;
    public static final int RIGHT_PWM_VALUE_FOR_STRAIGHT = 255;

    public enum State{
        READY_FOR_MISSION, RED_SCRIPT, BLUE_SCRIPT, WAITING_FOR_GPS, SEEKING_HOME, DRIVING_HOME, WAITING_FOR_PICKUP
    }
    private State mState = State.READY_FOR_MISSION;
    private long mStateStartTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_one_good_gps_reading);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        mCurrentStateTextView = (TextView) findViewById(R.id.current_state_textview);
        mStateTimeTextView = (TextView) findViewById(R.id.state_time_textview);
        mGpsInfoTextView = (TextView) findViewById(R.id.gps_info_textview);
        mSensorOrientationTextView = (TextView) findViewById(R.id.orientation_textview);

        mFieldGps = new FieldGps(this);
        mFieldOrientation = new FieldOrientation(this);

        setState(State.READY_FOR_MISSION);
    }

    @Override
    protected void onStart() {
        super.onStart();
//        mFieldGps.requestLocationUpdates(this);
        mFieldOrientation.registerListener(this);
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

    @Override
    protected void onStop() {
        super.onStop();
//        mFieldGps.removeUpdates();
        mFieldOrientation.unregisterListener();
    }

    private void loop(){
        mStateTimeTextView.setText("" + (System.currentTimeMillis() - mStateStartTime)/1000);
        switch(mState){
            case WAITING_FOR_GPS:
                if(System.currentTimeMillis() - mStateStartTime > 5000){
                    setState(State.SEEKING_HOME);
                }
                break;
            case SEEKING_HOME:
                if(System.currentTimeMillis() - mStateStartTime > 8000){
                    setState(State.WAITING_FOR_PICKUP);
                }
                break;
            case WAITING_FOR_PICKUP:
                if(System.currentTimeMillis() - mStateStartTime > 8000){
                    setState(State.SEEKING_HOME);
                }
                break;
            default:
                break;
        }
    }

    public void handleRedTeamGo(View view) {
        if(mState == State.READY_FOR_MISSION){
            setState(State.RED_SCRIPT);
        }
    }

    public void handleBlueTeamGo(View view) {
        if(mState == State.READY_FOR_MISSION){
            setState(State.BLUE_SCRIPT);
        }
    }

    public void handleFakeGps(View view) {
        onLocationChanged(40, 10, 135, null);
    }

    public void handleMissionComplete(View view) {
        mGpsInfoTextView.setText("---");
        if(mState == State.WAITING_FOR_PICKUP){
            setState(State.READY_FOR_MISSION);
        }
        sendCommand("CUSTOM Our team ROCKS!");
    }

    @Override
    protected void onCommandReceived(String receivedCommand) {
        super.onCommandReceived(receivedCommand);
        Toast.makeText(this, "Received: " + receivedCommand , Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onLocationChanged(double x, double y, double heading, Location location) {
        mGpsCounter++;
        mCurrentGpsX = x;
        mCurrentGpsY = y;
        mCurrentGpsHeading = heading;

        String gpsInfo = getString(R.string.xy_format,mCurrentGpsX,mCurrentGpsY);
        if(heading < 180.0 && heading > -180.0){
            gpsInfo += " " + getString(R.string.degrees_format,mCurrentGpsHeading);
            mCurrentGpsHeading = heading;
            if(mState == State.WAITING_FOR_GPS){
                setState(State.DRIVING_HOME);
            }
        } else {
            gpsInfo += " ?°";
        }
        gpsInfo += "    " + mGpsCounter;
        mGpsInfoTextView.setText(gpsInfo);
    }

    @Override
    public void onSensorChanged(double fieldHeading, float[] orientationValues) {
        mCurrentSensorHeading = fieldHeading;
        mSensorOrientationTextView.setText(getString(R.string.degrees_format,fieldHeading));
    }

    private void setState(State newState){
        mStateStartTime = System.currentTimeMillis();
        mCurrentStateTextView.setText(newState.name());

        switch(newState){
            case READY_FOR_MISSION:
                break;
            case RED_SCRIPT:
                script1();
                break;
            case BLUE_SCRIPT:
                script2();
                break;
            case SEEKING_HOME:
                break;
            case WAITING_FOR_GPS:
                break;
            case WAITING_FOR_PICKUP:
                break;
            case DRIVING_HOME:
                script3();
                break;
            default:
                break;
        }
        mState = newState;
    }

    private void script1(){
        Toast.makeText(OneGoodGpsReadingActivity.this,"RED",Toast.LENGTH_SHORT).show();
        sendCommand("WHEEL SPEED FORWARD 175 FORWARD 200");
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(OneGoodGpsReadingActivity.this,"Driving",Toast.LENGTH_SHORT).show();
                sendCommand("WHEEL SPEED FORWARD 150 FORWARD 175");
            }
        },2000);
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(mState == State.RED_SCRIPT){
                    setState(State.WAITING_FOR_GPS);
                }
                sendCommand("WHEEL SPEED FORWARD 150 FORWARD 150");
            }
        },4000);
    }

    private void script2(){
        Toast.makeText(OneGoodGpsReadingActivity.this,"BLUE",Toast.LENGTH_SHORT).show();
        sendCommand("WHEEL SPEED FORWARD 200 FORWARD 175");
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(OneGoodGpsReadingActivity.this,"DRIVING",Toast.LENGTH_SHORT).show();
                sendCommand("WHEEL SPEED FORWARD 175 FORWARD 150");
            }
        },2000);
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(mState == State.BLUE_SCRIPT){
                    setState(State.WAITING_FOR_GPS);
                }
                sendCommand("WHEEL SPEED FORWARD 150 FORWARD 150");
            }
        },4000);
    }

    private void script3(){
        Toast.makeText(OneGoodGpsReadingActivity.this,"DRIVING",Toast.LENGTH_SHORT).show();
        sendCommand("WHEEL SPEED FORWARD 150 FORWARD 250");
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(OneGoodGpsReadingActivity.this,"HOME",Toast.LENGTH_SHORT).show();
            }
        },3000);
        mCommandHandler.postDelayed(new Runnable() {
            @Override
            public void run() {
                if(mState == State.DRIVING_HOME){
                    setState(State.WAITING_FOR_PICKUP);
                }
                sendCommand("WHEEL SPEED BREAK 0 BREAK 0");
            }
        },5000);
    }

    private void seekTargetAt(double xTarget, double yTarget) {
        int leftDutyCycle = LEFT_PWM_VALUE_FOR_STRAIGHT;
        int rightDutyCycle = RIGHT_PWM_VALUE_FOR_STRAIGHT;
        double targetHeading = NavUtils.getTargetHeading(mCurrentGpsX, mCurrentGpsY, xTarget, yTarget);
        double leftTurnAmount = NavUtils.getLeftTurnHeadingDelta(mCurrentSensorHeading, targetHeading);
        double rightTurnAmount = NavUtils.getRightTurnHeadingDelta(mCurrentSensorHeading, targetHeading);
        if (leftTurnAmount < rightTurnAmount) {
            leftDutyCycle = LEFT_PWM_VALUE_FOR_STRAIGHT - (int)leftTurnAmount; // Using a VERY simple plan. :)
            leftDutyCycle = Math.max(leftDutyCycle, LOWEST_DESIRABLE_DUTY_CYCLE);
        } else {
            rightDutyCycle = RIGHT_PWM_VALUE_FOR_STRAIGHT - (int)rightTurnAmount; // Could also scale it.
            rightDutyCycle = Math.max(rightDutyCycle, LOWEST_DESIRABLE_DUTY_CYCLE);
        }
        sendCommand("WHEEL SPEED FORWARD " + leftDutyCycle + " FORWARD " + rightDutyCycle);
    }
}
