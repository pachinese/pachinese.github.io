/**
 * The Sign-In client object.
 */
var auth2;

/**
 * Initializes the Sign-In client.
 */
var initClient = function() {
    gapi.load('auth2', function(){
        /**
         * Retrieve the singleton for the GoogleAuth library and set up the
         * client.
         */
        auth2 = gapi.auth2.init({
            client_id: '168851110238-usqm6qmm44ghso2qt5g6i5o8h1jdna21.apps.googleusercontent.com'
        });

        // Attach the click handler to the sign-in button
        auth2.attachClickHandler('g-signin2', {}, onSuccess, onFailure);
    });
};

/**
 * Handle successful sign-ins.
 */
var onSuccess = function(user) {
    console.log('Signed in as ' + user.getBasicProfile().getName());
 };

/**
 * Handle sign-in failures.
 */
var onFailure = function(error) {
    console.log(error);
};

/**
 * Is user signed in.
 */
var isUserSignedIn = function() {
    gapi.load('auth2', function() {
        var isSignedIn = auth2.isSignedIn.get();
        console.log('is signed in? ', isSignedIn);
    });
};