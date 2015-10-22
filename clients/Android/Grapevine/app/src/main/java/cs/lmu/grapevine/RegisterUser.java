package cs.lmu.grapevine;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import cs.lmu.grapevine.requests.RegisterUserRequest;

public class RegisterUser extends AppCompatActivity {

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

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void attemptAccountCreation(View view) {
        EditText userEmailInput = (EditText)findViewById(R.id.register_user_username);
        EditText passwordInput = (EditText)findViewById(R.id.register_user_password);
        EditText passwordInputConfirm = (EditText)findViewById(R.id.register_user_confirm_password);

        String userEmail = userEmailInput.getText().toString();
        String password = passwordInput.getText().toString();
        String passwordConfirm = passwordInputConfirm.getText().toString();

        String requestBodyString =
                "{\"username\":\""
                        + userEmail
                        + "\",\"password\":\""
                        + password
                        + "\"}";

        RegisterUserRequest registerUserRequest= new RegisterUserRequest(this,requestBodyString);
        MainActivity.httpRequestQueue.add(registerUserRequest);

    }
}
