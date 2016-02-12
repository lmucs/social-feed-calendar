package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.Html;
import android.text.Spannable;
import android.text.method.LinkMovementMethod;
import android.text.style.URLSpan;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import cs.lmu.grapevine.Utils;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;

public class ViewEvent extends AppCompatActivity {
    private TextView eventTitleView;
    private TextView eventDateView;
    private TextView eventUrlView;
    private TextView originalPostView;
    private TextView singleEventDay;
    private TextView timeView;
    private TextView multiDayView;
    private TextView eventMonth;
    private TextView eventDay;
    private TextView feedName;

    private SimpleDateFormat timeOfEvent = new SimpleDateFormat("h:mm a", Locale.ENGLISH);
    private SimpleDateFormat fullDate = new SimpleDateFormat("MM/d/yy",Locale.ENGLISH);
    private SimpleDateFormat monthAbbreviated = new SimpleDateFormat(("LLL"),Locale.ENGLISH);
    private SimpleDateFormat dayInMonth = new SimpleDateFormat("d",Locale.ENGLISH);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);
        getUiElements();
        setTitle();

        Intent intent = getIntent();
        Event eventToView = (Event)intent.getSerializableExtra("event");
        displayEvent(eventToView);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_view_event, menu);
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

    public void displayEvent(Event eventToDisplay) {

        if (!(eventToDisplay.getTitle() == null)) {
            if (eventToDisplay.getTitle().length() > 30) {
                eventTitleView.setTextSize(TypedValue.COMPLEX_UNIT_SP,20);
            }
            eventTitleView.setText(eventToDisplay.getTitle());
        } else {
            eventTitleView.setText(R.string.untitled_event_title);
        }

        eventDay.setText(dayInMonth.format(eventToDisplay.getStartDate()));
        eventMonth.setText(monthAbbreviated.format(eventToDisplay.getStartDate()));

        if (!(eventToDisplay.getPostContent() == null)
         && !(eventToDisplay.getPostContent().equals(""))) {
            originalPostView.setText(eventToDisplay.getPostContent());
        } else {
            originalPostView.setText(R.string.no_post_content_message);
        }

        if (eventToDisplay.startsLaterToday()) {
            if (eventToDisplay.endTimeIsKnown()) {
                timeView.setText(
                      timeOfEvent.format(eventToDisplay.getStartDate())
                      + " - "
                      + timeOfEvent.format(eventToDisplay.getEndDate())
                );
            } else {
                timeView.setText(timeOfEvent.format(eventToDisplay.getStartDate()));
            }
            eventDateView.setText("today");
        } else if(!(eventToDisplay.endTimeIsKnown())) {
            timeView.setText(timeOfEvent.format(eventToDisplay.getStartDate()));
        } else if (eventToDisplay.endsLaterToday()) {
            timeView.setText("ends today at " + timeOfEvent.format(eventToDisplay.getEndDate()));
        } else {
           eventDateView.setVisibility(View.INVISIBLE);
            if (eventToDisplay.getStartTimeTimestamp() != 0) {
                timeView.setText(
                        timeOfEvent.format(eventToDisplay.getStartDate())
                                + " - "
                                + timeOfEvent.format(eventToDisplay.getEndDate())
                );
            } else {
                timeView.setText(timeOfEvent.format(eventToDisplay.getStartDate()));
            }
        }

        if (eventToDisplay.isMultiDay()) {
            multiDayView.setVisibility(View.VISIBLE);
            timeView.setVisibility(View.GONE);

            eventDateView.setText(fullDate.format(eventToDisplay.getStartDate()) + " - " + fullDate.format(eventToDisplay.getEndDate()));

            if (eventToDisplay.isToday()) {
                eventMonth.setText(monthAbbreviated.format(new Date(Calendar.getInstance().getTimeInMillis())));
                eventDay.setText(dayInMonth.format(new Date(Calendar.getInstance().getTimeInMillis())));
            }
        }

        if (!(eventToDisplay.getUrl() == null)) {
            String htmlUrlString = "<a href=\"" + eventToDisplay.getUrl() + "\">" + getString(R.string.view_original_post) + "</a > ";
            eventUrlView.setText(Html.fromHtml(htmlUrlString));
            eventUrlView.setMovementMethod(LinkMovementMethod.getInstance());
            removeUnderlines((Spannable) eventUrlView.getText());
        }

        String location = "";
        HashMap<String, String> eventLocation = eventToDisplay.getLocation();
        if ((eventLocation != null)) {
            if (eventLocation.get("name") != null) {
                location += eventLocation.get("name");
            }
        } else {

            if (eventLocation.get("street") != null){
                location += eventLocation.get("street");
            }

            if (eventLocation.get("state") != null) {
                location += eventLocation.get("state");
            }

            if (eventLocation.get("country") != null) {
                location += eventLocation.get("country");
            }

        }
        originalPostView.append(location);

        LinearLayout tags = (LinearLayout)findViewById(R.id.tags);
        if (eventToDisplay.getTags().length != 0) {
            for (String tag : eventToDisplay.getTags()) {
                TextView tagView = new TextView(this);
                tagView.setText("#" + tag);
                tags.addView(tagView);
                tagView.setGravity(Gravity.CENTER);
            }
        }

        feedName.setText(eventToDisplay.getAuthor());
    }

    public static void removeUnderlines(Spannable p_Text) {
        URLSpan[] spans = p_Text.getSpans(0, p_Text.length(), URLSpan.class);

        for(URLSpan span:spans) {
            int start = p_Text.getSpanStart(span);
            int end = p_Text.getSpanEnd(span);
            p_Text.removeSpan(span);
            span = new Utils.URLSpanNoUnderline(span.getURL());
            p_Text.setSpan(span, start, end, 0);
        }
    }

    private void getUiElements() {
        eventTitleView    = (TextView)findViewById(R.id.single_event_title);
        eventDateView     = (TextView) findViewById(R.id.single_event_date);
        eventUrlView      = (TextView) findViewById(R.id.single_event_url);
        originalPostView  = (TextView) findViewById(R.id.single_event_original_post);
        timeView          = (TextView) findViewById(R.id.time);
        multiDayView      = (TextView) findViewById(R.id.multi_day);
        eventMonth        = (TextView) findViewById(R.id.event_month);
        eventDay          = (TextView) findViewById(R.id.event_day);
        feedName          = (TextView) findViewById(R.id.feed_name);
        singleEventDay    = (TextView) findViewById(R.id.single_event_date);
    }

    private void setTitle() {
        final ActionBar actionBar = getSupportActionBar();
        actionBar.setCustomView(R.layout.action_bar);
        actionBar.setDisplayShowCustomEnabled(true);
        actionBar.setDisplayShowTitleEnabled(false);
    }

}