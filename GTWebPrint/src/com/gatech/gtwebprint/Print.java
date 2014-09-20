package com.gatech.gtwebprint;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.InputStreamBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.TextView;

public class Print extends ActionBarActivity {

	private InputStream file;
	private String usr;
	private String ptr;
	private String result;

	private class PostFile extends Thread {
		public void run() {
			HttpClient httpclient = new DefaultHttpClient();
			HttpPost httppost = new HttpPost(
					"http://192.168.1.120/printfile.php");

			try {
				MultipartEntity entity = new MultipartEntity();

				entity.addPart("usr", new StringBody(usr));
				entity.addPart("ptr", new StringBody(ptr));
				entity.addPart("file", new InputStreamBody(file, "DownloadedPDF.pdf"));
				httppost.setEntity(entity);
				HttpResponse response = httpclient.execute(httppost);
				String result = EntityUtils.toString(response.getEntity());
				
			} catch (ClientProtocolException e) {
				result = e.toString();
			} catch (IOException e) {
				result = e.toString();
			}
		}
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_print);
		Intent intent = this.getIntent();
		try {
			file = getContentResolver().openInputStream( (Uri) intent.getParcelableExtra(Intent.EXTRA_STREAM));
		} catch (FileNotFoundException e1) {
		}
		

		final Button button = (Button) findViewById(R.id.button1);
		button.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				usr = ((EditText) findViewById(R.id.editText1)).getText()
						.toString();
				ptr = "";
				if (((RadioButton) findViewById(R.id.radio0)).isChecked()) {
					ptr = ((RadioButton) findViewById(R.id.radio0)).getText()
							.toString();
				}
				if (((RadioButton) findViewById(R.id.radio1)).isChecked()) {
					ptr = ((RadioButton) findViewById(R.id.radio1)).getText()
							.toString();
				}
				Thread postFile = new PostFile();
				postFile.start();
				try {
					postFile.join();
				} catch (InterruptedException e) {
				}
				setResult(Activity.RESULT_OK);
				finish();
			}
		});

	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.print, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		// Handle action bar item clicks here. The action bar will
		// automatically handle clicks on the Home/Up button, so long
		// as you specify a parent activity in AndroidManifest.xml.
		int id = item.getItemId();
		if (id == R.id.action_settings) {
			return true;
		}
		return super.onOptionsItemSelected(item);
	}
}
