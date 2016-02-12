package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.widget.ListView;
import android.widget.TextView;
import com.android.volley.Response;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import org.json.JSONArray;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.ManageFeeds;
import cs.lmu.grapevine.adapters.SocialMediaListAdapter;
import cs.lmu.grapevine.entities.SocialMediaFeed;
import cs.lmu.grapevine.listeners.SocialMediaFeedClickListener;

/**
 * Created by jeff on 12/4/15.
 */
public class RetrieveUserFeedsSuccessListener implements Response.Listener<JSONArray> {
    private Activity parentActivity;

    public RetrieveUserFeedsSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onResponse(JSONArray response) {
        ArrayList<SocialMediaFeed> feedsFollowed = deserializeJsonIntoFeedList(response);
        Collections.sort(feedsFollowed);
        ManageFeeds.feedsFollowed = feedsFollowed;
        populateFeedListWith(feedsFollowed);
    }

    private ArrayList<SocialMediaFeed> deserializeJsonIntoFeedList(JSONArray usersFeedsJson) {
        Gson gson = new Gson();
        ArrayList<SocialMediaFeed> feedsFollowed = gson.fromJson(usersFeedsJson.toString(),new TypeToken<List<SocialMediaFeed>>() {
        }.getType());

        return feedsFollowed;
    }

    private void populateFeedListWith(ArrayList<SocialMediaFeed> feedsFollowed) {
        if (feedsFollowed.isEmpty()) {
            setNoFeedsMessage();
        } else {
            SocialMediaListAdapter adapter = new SocialMediaListAdapter(parentActivity,feedsFollowed);
            ListView socialMediaFeedList = (ListView)parentActivity.findViewById(R.id.currently_following);
            socialMediaFeedList.setAdapter(adapter);
            ManageFeeds.feedsAdapter = adapter;
            socialMediaFeedList.setOnItemLongClickListener(new SocialMediaFeedClickListener(parentActivity));
            clearNoFeedsMessage();
        }
    }

    public void setNoFeedsMessage() {
        TextView emptyMessage = (TextView)parentActivity.findViewById(R.id.no_feeds_message);
        emptyMessage.setText(R.string.no_feeds_message);
    }

    public void clearNoFeedsMessage() {
        TextView emptyMessage = (TextView)parentActivity.findViewById(R.id.no_feeds_message);
        emptyMessage.setText("");
    }
}
