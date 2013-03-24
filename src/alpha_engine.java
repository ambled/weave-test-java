/*
 * Copyright 2012-2013 Garth Johnson as Weave.sh
 * Copyright 2008-2010 Plura Processing, LP 
 *
 * This simple headless client accepts an optional clientId as it's only argument
 *
 * If you are building this test for yourself:
 *    Please send a request to optin@weave.sh,
 *    A valid clientId will be returned to the same address as validation.
 *    This registration process is manual right now and may take 24 hours for a response
 * If you fail to use a registered clientId, completed work will not earn credit
 */
package sh.weave;

import java.util.Calendar;

// This version of the client uses the Plura Processing network
// Partner library here: http://www.pluraprocessing.com/developer/downloads/plura-affiliate-app-connector.jar
// Import the modules we need from the jar
import com.pluraprocessing.node.affiliate.desktop.JavaPluraConnector;
import com.pluraprocessing.node.exception.PluraInitializationException;
import com.pluraprocessing.node.exception.PluraIntervalException;
import com.pluraprocessing.node.exception.PluraLoadException;
import com.pluraprocessing.node.exception.PluraParameterException;
import com.pluraprocessing.node.exception.PluraStateException;

/*
 * Here we setup the main class
 */
public class alpha_engine {

	/*
	 * This method uses the JavaPluraConnector functionality to receive work requests
	 */
	public static void main(String[] args) {

		// Define a connector
		JavaPluraConnector plura = null;

		// Hardcoded clientId prefix, will use registration system later
		String FiberAnchor = "1c5b8t1hr"; //1 cpu @ 50% usage, 80% bandwidth, 1 hour session
		String FiberId     = FiberAnchor + "-";

		//Allow registered members to provide their own grid sessionId to award completed units
		if (args.length > 1) {
			System.err.println("The test client only accepts a single (optional) string as an identifier\n");
			System.exit(1);
		} 
		//Make sure we limit clientId to a valid length
		if (args.length > 0) {
			String firstArg = args[0];
			try {
				if (firstArg.length() < (40 - FiberId.length())) {
					FiberId += firstArg;
				} else {
					FiberId += args[0].substring(0,40-(FiberId.length()));
				}
			} catch (Exception e) {
				System.err.println("Unable to append optional identifier " + firstArg + " to FiberId " + FiberAnchor);
				System.err.println("Exception: " + e.getMessage());
				System.exit(1);
			}
		}
                //Set a default FiberId
                if (args.length == 0) {
                        FiberId += "helloworld";
                }
		
                //Now, we initiate a connection using the provider library
		try {
			/* instantiate new JavaPluraConnector 
                         * test affiliate id = d45f5668-672a-105a-80ab-fa23fc6ac15d,
                         * cpu percentage = .5, 50%
                         * bandwidth percentage = .8, 80%
                         * client id = FiberId, FiberAnchor+optional user info
                         * max plura threads = 1 (to use n cores on a computer)
                         * session contract 1 hour
                         */
			plura = new JavaPluraConnector("d45f5668-672a-105a-80ab-fa23fc6ac15d", .5, .8, FiberId, 1); 
			
			System.out.println("start Plura with FiberId: " + FiberId); 

			plura.start(); //start Plura at 80% bandwidth usage, 50% cpu usage, and 1 Plura threads max
			
			Thread.sleep(3600000); // 3600 seconds = 3600 000 milliseconds == 1 hour
	
			System.out.println("stop Plura"); 
			plura.stop(); //stop Plura

		} 
		catch (PluraInitializationException e) {
			e.printStackTrace(System.out);
		} 
                //Caught when Thread sleep timer goes off
                catch (InterruptedException e) {
                        e.printStackTrace(System.out);
                }
		catch (PluraLoadException e) {
			e.printStackTrace(System.out);
		} 
		catch (PluraParameterException e) {
			e.printStackTrace(System.out);
		} 
		catch (PluraStateException e) {
			e.printStackTrace(System.out);
		}
		finally {
			if (plura != null) {
				plura.stop(); //Stop Plura before the application exits (even if it exits on error) so that Plura threads are not abandoned.
			}
		}
	}

}




