package cs.lmu.grapevine.requests.listeners.error;

import android.app.Activity;
import android.widget.TextView;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import cs.lmu.grapevine.R;

/**
 * Listener for unsuccessful EventFeedRequests.
 */
public class EventErrorListener implements Response.ErrorListener {
    private Activity parentActivity;

    public EventErrorListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
        TextView loginStatus = (TextView)parentActivity.findViewById(R.id.event_request_status);
        loginStatus.setText(R.string.account_exists);
    }
}