package cs.lmu.grapevine.activities;

import android.app.Activity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.requests.RegisterUserRequest;

public class RegisterUser extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register_user);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_register_user, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        return super.onOptionsItemSelected(item);
    }

    public void attemptAccountCreation(View view) {
        boolean inputsValid = true;
        EditText usernameInput        = (EditText)findViewById(R.id.register_user_username);
        EditText passwordInput        = (EditText)findViewById(R.id.register_user_password);
        EditText passwordInputConfirm = (EditText)findViewById(R.id.register_user_confirm_password);
        EditText emailInput           = (EditText)findViewById(R.id.register_user_email_address);
        EditText firstNameInput       = (EditText)findViewById(R.id.register_user_first_name);
        EditText lastNameInput        = (EditText)findViewById(R.id.register_user_last_name);

        String username = usernameInput.getText().toString().trim();
        String password = passwordInput.getText().toString().trim();
        String passwordConfirm = passwordInputConfirm.getText().toString().trim();
        String email = emailInput.getText().toString().trim();
        String firstName = firstNameInput.getText().toString().trim();
        String lastName = lastNameInput.getText().toString().trim();

        if (username.equals("")) {
            inputsValid = false;
            usernameInput.setError("Please enter your user name");
        }

        if (firstName.equals("")) {
            inputsValid = false;
            firstNameInput.setError("Please enter your first name");
        }

        if (lastName.equals("")) {
            inputsValid = false;
            lastNameInput.setError("Please enter your last name");
        }

        if (email.equals("")) {
            inputsValid = false;
            emailInput.setError("Please enter your email.");
        }

        if (password.equals("")) {
            inputsValid = false;
            passwordInput.setError("Please enter a password");
        }

        if (!password.equals(passwordConfirm)) {
            inputsValid = false;
            passwordInput.setError("Passwords do not match");
            passwordInputConfirm.setError("Passwords do not match");
        }

        if (passwordConfirm.equals("")) {
            inputsValid = false;
            passwordInputConfirm.setError("Please type password again");
        }

        if (inputsValid) {
            String requestBodyString =
                    "{\"username\":\""
                            + username
                            + "\",\"password\":\""
                            + password
                            + "\",\"firstName\":\""
                            + firstName
                            + "\",\"email\":\""
                            + email
                            + "\",\"lastName\":\""
                            + lastName
                            + "\"}";

            RegisterUserRequest registerUserRequest= new RegisterUserRequest(this,requestBodyString);
            Login.httpRequestQueue.add(registerUserRequest);
        }

    }
}
