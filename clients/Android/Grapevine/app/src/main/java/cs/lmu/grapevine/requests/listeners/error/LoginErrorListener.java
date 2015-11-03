package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.AuthFailureError;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Listener for unsuccessful LoginRequests.
 */
public class LoginErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public LoginErrorListener(Activity activity) {
        this.parentActivity = activity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        TextView loginStatus = (TextView)parentActivity.findViewById(R.id.login_status);

        if (error instanceof AuthFailureError) {
            loginStatus.setText(R.string.auth_failure_message);
        } else {
            loginStatus.setText(R.string.general_login_error);
        }
    }
}