package cs.lmu.grapevine.requests.listeners;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Error Listener for unsuccessful RegisterUserRequests.
 */
public class RegisterUserErrorListener implements Response.ErrorListener{
    private Activity parentActivity;

    public RegisterUserErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        TextView registerUserStatus = (TextView)parentActivity.findViewById(R.id.create_user_status);
        if (error.networkResponse.statusCode == 400) {
            registerUserStatus.setText(R.string.account_exists);
        } else {
            registerUserStatus.setText(R.string.register_user_general_error);
        }

    }
}