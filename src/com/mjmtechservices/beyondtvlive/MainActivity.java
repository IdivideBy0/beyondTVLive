package com.mjmtechservices.beyondtvlive;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;
import com.mjmtechservices.beyondtvlive.R;

public class MainActivity extends Activity {
	final Context context = this;

	/** Called when the activity is first created. */
	
	
	
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
	    MenuInflater inflater = getMenuInflater();
	    inflater.inflate(R.menu.main, menu);
	    return true;
	}
	
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
	    // Handle item selection
	    switch (item.getItemId()) {
	        case R.id.action_settings:
	        	
	        	TextView txtView = (TextView) findViewById(R.id.textView1);
	        	EditText editTxt = (EditText) findViewById(R.id.editText1);
	        	Button btn = (Button)findViewById(R.id.button1) ;
	        	
	            //Show the settings widgets
	        	txtView.setVisibility(View.VISIBLE);
				editTxt.setVisibility(View.VISIBLE);
				btn.setVisibility(View.VISIBLE);
				
				// if there are values in settings, show them
				SharedPreferences settings = getSharedPreferences("BTVMobile", 0);
				String strURL = settings.getString("BTVUrl", "");
				
				if(strURL != ""){
					editTxt.setText(strURL);
				}
				
				
	            return true;
	        //case R.id.help:
	            //showHelp();
	        //    return true;
	        default:
	            return super.onOptionsItemSelected(item);
	    }
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		
		makeRequest();

		

	}
	
	public void makeRequest(){
		
		// logic to read the URL 
				SharedPreferences settings = getSharedPreferences("BTVMobile", 0);
				
				String strURL = settings.getString("BTVUrl", "") ;
				
				if(strURL != "")
				{
				LoadWebPageASYNC task = new LoadWebPageASYNC();
				//task.execute(new String[] { "http://beyondtvhost:8129/mobile" });
				
				//hide url and save button
				TextView txtView = (TextView) findViewById(R.id.textView1);
				EditText editTxt = (EditText) findViewById(R.id.editText1);
				Button btn = (Button)findViewById(R.id.button1) ;
				
				txtView.setVisibility(View.GONE);
				editTxt.setVisibility(View.GONE);
				btn.setVisibility(View.GONE);
				
				
				task.execute(new String[] { strURL });
				}
				else {
					Toast.makeText(MainActivity.this, "BTVServer URL not found in prefs!", Toast.LENGTH_SHORT).show();
				}
		
	}

	private class LoadWebPageASYNC extends AsyncTask<String, Void, String> {

		@Override
		protected String doInBackground(String... urls) {

			WebView webView = (WebView) findViewById(R.id.webView);
			webView.getSettings().setJavaScriptEnabled(true);
			//webView.setWebViewClient(new WebViewClient());
			webView.setWebViewClient(new VideoWebViewClient());
			webView.loadUrl(urls[0]);

			return null;
		}

		@Override
		protected void onPostExecute(String result) {

		}
	}
	
	private class VideoWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            try{
                System.out.println("url called:::" + url);
                if (url.startsWith("mms:")) {
                	
                	Uri uri = Uri.parse(url);
                    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                    intent.setDataAndType(uri,"video/*");
                    startActivity(intent);
                } // else if (url.startsWith("http:")
                  //      || url.startsWith("https:")) {

                 //    Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url)); 
                 //    startActivity(intent);

                //}
                else {
                    return false;
                }
            }catch(Exception e){
                e.printStackTrace();
            }

            return true;
        }

    }
	
	public void saveURL(View view){
		
		
		EditText editTxt = (EditText) findViewById(R.id.editText1);
		
		String strURL = editTxt.getText().toString();

		
		SharedPreferences preferences = getSharedPreferences("BTVMobile", MODE_PRIVATE);
		SharedPreferences.Editor edit= preferences.edit();

		
		edit.putString("BTVUrl", strURL );
		edit.commit();
		
		makeRequest(); // try to load the page immediately after save.
		

	}

}