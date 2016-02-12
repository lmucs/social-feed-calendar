package cs.lmu.grapevine.activities;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;
import java.util.ArrayList;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.entities.SocialMediaFeed;
import cs.lmu.grapevine.requests.FollowFeedRequest;
import cs.lmu.grapevine.requests.RetrieveFeedsUserFollowingRequest;

public class ManageFeeds extends AppCompatActivity {
    private EditText   feedNameEditText;
    private RadioGroup feedSources;
    private Button     addFeedButton;
    public static ArrayList<SocialMediaFeed> feedsFollowed;
    public static ArrayAdapter feedsAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.manage_feeds);

        grabReferencesToEditTextAndButton();
        addListenerToTextView();
        getFeedsUserFollows();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_manage_feeds, menu);
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

    public void addGroupIfValid(View view) {
        clearErrorMessage();
        RadioGroup socialMediaGroup = (RadioGroup) findViewById(R.id.social_media_options);
        TextView groupNameTextView = (TextView) findViewById(R.id.feed_name);

        int feedRadioButtonId = socialMediaGroup.getCheckedRadioButtonId();
        String feedName = groupNameTextView.getText().toString().trim();

        String sourceName = (String)((RadioButton)findViewById(feedRadioButtonId)).getText();

        if (!(feedName.equals(""))) {
            String requestBodyString =
                    "{\"feedName\":\""
                            + feedName
                            + "\",\"networkName\":\""
                            + sourceName.toLowerCase()
                            + "\"}";

            FollowFeedRequest followGroupRequest = new FollowFeedRequest(this, requestBodyString);
            Login.httpRequestQueue.add(followGroupRequest);
        }
    }

    public void addListenerToTextView() {

        feedNameEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                checkInputsAndToggleButton();
                clearErrorMessage();
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
    }

    public void toggleButtonIfInputsValid(View view){
        checkInputsAndToggleButton();
    }

    public void clearErrorMessage() {
        TextView errorMessage = (TextView)findViewById(R.id.feed_error_message);
        errorMessage.setText("");
    }

    public void checkInputsAndToggleButton(){
        if (!feedNameEditText.getText().toString().trim().equals("") && feedSources.getCheckedRadioButtonId() != -1) {
            addFeedButton.setEnabled(true);
        } else {
            addFeedButton.setEnabled(false);
        }
    }

    private void grabReferencesToEditTextAndButton() {
        feedNameEditText = (EditText)findViewById(R.id.feed_name);
        addFeedButton = (Button)findViewById(R.id.add_feed_button);
        feedSources = (RadioGroup)findViewById(R.id.social_media_options);
    }

    private void getFeedsUserFollows() {
        RetrieveFeedsUserFollowingRequest getFeeds = new RetrieveFeedsUserFollowingRequest(this);
        Login.httpRequestQueue.add(getFeeds);
    }
}
