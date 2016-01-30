package cs.lmu.grapevine.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import java.util.Date;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.UserProfile;
import cs.lmu.grapevine.requests.LoginRequest;

public class Login extends Activity {

    public static AutoCompleteTextView mEmailView;
    private       EditText             mPasswordView;
    public static RequestQueue         httpRequestQueue;
    public static long                 lastRefresh;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        if (UserProfile.isLoggedIn(this)) {
            launchEventFeed();
        }

        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);
        mEmailView = (AutoCompleteTextView) findViewById(R.id.email);
        mPasswordView = (EditText) findViewById(R.id.password);
        mPasswordView.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView textView, int id, KeyEvent keyEvent) {
                if (id == R.id.login || id == EditorInfo.IME_NULL) {
                    attemptLogin();
                    return true;
                }
                return false;

            }
        });

        Button mEmailSignInButton = (Button) findViewById(R.id.email_sign_in_button);
        mEmailSignInButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                attemptLogin();
            }
        });

        httpRequestQueue = Volley.newRequestQueue(this);
        lastRefresh = new Date().getTime();
    }

    /**
     * Attempts to sign in or register the account specified by the login form.
     * If there are form errors (invalid email, missing fields, etc.), the
     * errors are presented and no actual login attempt is made.
     */
    public void attemptLogin(){

        // Reset errors.
        mEmailView.setError(null);
        mPasswordView.setError(null);

        clearErrorMessage();

        // Store values at the time of the login attempt.
        String email = mEmailView.getText().toString();
        String password = mPasswordView.getText().toString();

        boolean cancel = false;
        View focusView = null;

        if (!TextUtils.isEmpty(password) && !isPasswordValid(password)) {
            mPasswordView.setError(getString(R.string.error_invalid_password));
            focusView = mPasswordView;
            cancel = true;
        }

        if (TextUtils.isEmpty(email)) {
            mEmailView.setError(getString(R.string.error_field_required));
            focusView = mEmailView;
            cancel = true;
        } else if (!isEmailValid(email)) {
            mEmailView.setError(getString(R.string.error_invalid_email));
            focusView = mEmailView;
            cancel = true;
        }

        if (cancel) {
            // There was an error; don't attempt login and focus the first
            // form field with an error.
            focusView.requestFocus();
        } else {
            String userEmail = mEmailView.getText().toString();
            String userPassword = mPasswordView.getText().toString();

            String requestBodyString =
                    "{\"username\":\""
                     + userEmail
                     + "\",\"password\":\""
                     + userPassword
                     + "\"}";

            LoginRequest userLoginRequest = new LoginRequest(this, requestBodyString);
            httpRequestQueue.add(userLoginRequest);
        }
    }

    private boolean isEmailValid(String email) {
        return email.length() > 0;
    }

    private boolean isPasswordValid(String password) {
        //TODO: Replace this with your own logic
        return password.length() > 1;
    }

    public void launchCreateAccountActivity(View view) {
        Intent createNewAccount = new Intent(getApplicationContext(), RegisterUser.class);
        startActivity(createNewAccount);
    }

    private void hideKeyboard() {
        InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
        imm.toggleSoftInput(InputMethodManager.HIDE_IMPLICIT_ONLY, 0);
    }

    private void clearErrorMessage() {
        TextView loginStatus = (TextView)findViewById(R.id.login_status);
        loginStatus.setText("");
    }

    private void launchEventFeed() {
        Intent eventFeed = new Intent(this, EventFeed.class);
        startActivity(eventFeed);
    }
}
