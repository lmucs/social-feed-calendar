package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Html;
import android.text.Spannable;
import android.text.method.LinkMovementMethod;
import android.text.style.URLSpan;
import android.util.TypedValue;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.TextView;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import cs.lmu.grapevine.Utils;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;

public class ViewEvent extends AppCompatActivity {
    private TextView eventTitleView;
    private TextView eventDateView;
    private TextView eventLocationView;
    private TextView tags;
    private TextView eventUrlView;
    private TextView originalPostView;
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
        Date now = new Date(Calendar.getInstance().getTimeInMillis());

        if (!(eventToDisplay.getTitle() == null)) {
            if (eventToDisplay.getTitle().length() > 30) {
                eventTitleView.setTextSize(TypedValue.COMPLEX_UNIT_SP,20);
            }
            eventTitleView.setText(eventToDisplay.getTitle());
        } else {
            eventTitleView.setText(R.string.untitled_event_title);
        }

        if (!(eventToDisplay.getTags() == null)){
            String tagString = "";
            for (String tag: eventToDisplay.getTags()) {
                tagString += new String(Character.toChars(getEmojiForTag(tag)));
            }
            tags.setText(tagString);
        } else {
            tags.setText("");
        }

        eventDay.setText(dayInMonth.format(eventToDisplay.getStartDate()));
        eventMonth.setText(monthAbbreviated.format(eventToDisplay.getStartDate()));
        //TODO - INSERT LOCATION

        if (!(eventToDisplay.getPostContent() == null)
         && !(eventToDisplay.getPostContent().equals(""))) {
            originalPostView.setText(eventToDisplay.getPostContent());
        } else {
            originalPostView.setText(R.string.no_post_content_message);
        }

        if (eventToDisplay.startsLaterToday()) {
            if (eventToDisplay.getStartTimeTimestamp() != 0) {
                timeView.setText(
                        "today from "
                      + timeOfEvent.format(eventToDisplay.getStartDate())
                      + " - "
                      + timeOfEvent.format(eventToDisplay.getEndDate())
                );
            } else {
                timeView.setText("today at " + timeOfEvent.format(eventToDisplay.getStartDate()));
                eventDateView.setVisibility(View.INVISIBLE);
            }
        } else if (eventToDisplay.endsLaterToday()) {
            timeView.setText("ends today at " + timeOfEvent.format(eventToDisplay.getEndDate()));
        } else {
            timeView.setText(fullDate.format(eventToDisplay.getStartDate()));
        }

        if (eventToDisplay.isMultiDay()) {
            multiDayView.setVisibility(View.VISIBLE);
            eventDateView.setVisibility(View.INVISIBLE);

            timeView.setText(fullDate.format(eventToDisplay.getStartDate()) + " - " + fullDate.format(eventToDisplay.getEndDate()));

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

        feedName.setText(eventToDisplay.getAuthor());

    }

    public static int getEmojiForTag(String tag) {
        int emojiUnicode = 0;
        int[] possibleFoodEmojis = new int[]{0x1F372, 0x1F355, 0x1F347, 0x1F34E, 0x1F374, 0x1F355, 0x1F354};
        int[] possibleEntertainmentEmojis = new int[]{0x1F3A4, 0x2B50, 0x1F0CF, 0x1F3A5, 0x1F3AD};
        int[] possibleSportsEmojis = new int[]{0x26BD, 0x1F3C8, 0x1F3C1, 0x1F3C0};
        switch (tag) {
            case "entertainment": emojiUnicode = possibleEntertainmentEmojis[randomIndex(possibleEntertainmentEmojis.length)];
                                  break;
            case "food": emojiUnicode = possibleFoodEmojis[randomIndex(possibleFoodEmojis.length)];
                         break;
            case "sports": emojiUnicode = possibleSportsEmojis[randomIndex(possibleSportsEmojis.length)];
                break;
        }
        return emojiUnicode;
    }

    public static int randomIndex(int upperBound) {
        return (int) Math.floor(Math.random()*upperBound);
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
        eventLocationView = (TextView) findViewById(R.id.single_event_location);
        eventUrlView      = (TextView) findViewById(R.id.single_event_url);
        originalPostView  = (TextView) findViewById(R.id.single_event_original_post);
        timeView          = (TextView) findViewById(R.id.time);
        multiDayView      = (TextView) findViewById(R.id.multi_day);
        eventMonth        = (TextView) findViewById(R.id.event_month);
        eventDay          = (TextView) findViewById(R.id.event_day);
        feedName          = (TextView) findViewById(R.id.feed_name);
        tags              = (TextView) findViewById(R.id.tags);
    }
}