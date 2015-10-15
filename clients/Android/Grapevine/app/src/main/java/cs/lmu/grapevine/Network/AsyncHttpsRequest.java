package cs.lmu.grapevine.Network;

import android.os.AsyncTask;
import android.util.Log;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;

public class AsyncHttpsRequest extends AsyncTask<String, String, String> {

    @Override
    protected String doInBackground(String... params) {
        if (params.length > 2) {
            throw new IllegalArgumentException("The only arguments should be a URL and an optional JSON string");
        }

        String urlString = (String)params[0];
        URL serverURL;
        Certificate serverCertificate;
        try{
            serverURL = new URL(urlString);
            URLConnection urlConnection = serverURL.openConnection();
            CertificateFactory cf = CertificateFactory.getInstance("X.509");
            InputStream in = urlConnection.getInputStream();
            serverCertificate = cf.generateCertificate(in);
            Log.d("ca=", ((X509Certificate) serverCertificate).getSubjectDN().toString());
        }
        catch (CertificateException c) {
            Log.e("exception", "Certificate Exception occured", c);
        }
        catch (IOException i){
            Log.e("exception", "IO Exception occured", i);
        }
        return null;
    }
}
