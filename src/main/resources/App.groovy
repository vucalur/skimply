// Our application config - you can maintain it here or alternatively you could
// stick it in a conf.json text file and specify that on the command line when
// starting this verticle

// Configuration for the web server
def webServerConf = [
    // Normal web server stuff
    port              : (container.env['OPENSHIFT_VERTX_PORT'] ?: '8080').toInteger(),
    host              : container.env['OPENSHIFT_VERTX_IP'] ?: '0.0.0.0',
    ssl               : false,  // Openshift deals with SSL for us
    "auto-redeploy"   : true,   // TODO(vucalur): Override with false on deployment

    // Configuration for the event bus client side bridge
    // This bridges messages from the client side to the server side event bus
    bridge            : true,

    // This defines which messages from the client we will let through
    // to the server side
    inbound_permitted : [
        // Allow calls to login
        [
            address: 'vertx.basicauthmanager.login'
        ],
        [
            address      : 'vertx.mongopersistor',
            requires_auth: true,  // User must be logged in to send let these through
            match        : [
                action    : 'save',
                collection: 'orders'
            ]
        ]
    ],

    // This defines which messages from the server we will let through to the client
    outbound_permitted: [
        [:]
    ]
]


def mongoconf = [
    host    : container.env['OPENSHIFT_MONGODB_DB_HOST'] ?: 'localhost',
    port    : (container.env['OPENSHIFT_MONGODB_DB_PORT'] ?: '27017').toInteger(),
    username: container.env['OPENSHIFT_MONGODB_DB_USERNAME'],
    password: container.env['OPENSHIFT_MONGODB_DB_PASSWORD'],
    db_name : (container.env['OPENSHIFT_APP_NAME'] ?: 'skimply')
]

container.with {

    // Deploy a MongoDB persistor module

    deployModule('io.vertx~mod-mongo-persistor~2.0.0-final', mongoconf) { asyncResult ->
        if (asyncResult.succeeded) {
            // And when it's deployed run a script to load it with some reference
            // data for the demo
            deployVerticle('DataLoader.groovy')
        } else {
            println "Failed to deploy ${asyncResult.cause}"
        }
    }

    // Deploy an auth manager to handle the authentication

    deployModule('io.vertx~mod-auth-mgr~2.0.0-final')

    // Start the web server, with the config we defined above

    deployModule('io.vertx~mod-web-server~2.0.0-final', webServerConf)

}
