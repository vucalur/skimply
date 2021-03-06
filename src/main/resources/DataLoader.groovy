def eb = vertx.eventBus

def pa = 'vertx.mongopersistor'

def albums = [
    [
        'artist': 'The Wurzels',
        'genre' : 'Scrumpy and Western',
        'title' : 'I Am A Cider Drinker',
        'price' : 0.99
    ],
    [
        'artist': 'Vanilla Ice',
        'genre' : 'Hip Hop',
        'title' : 'Ice Ice Baby',
        'price' : 0.01
    ],
    [
        'artist': 'Ena Baga',
        'genre' : 'Easy Listening',
        'title' : 'The Happy Hammond',
        'price' : 0.50
    ],
    [
        'artist': 'The Tweets',
        'genre' : 'Bird related songs',
        'title' : 'The Birdy Song',
        'price' : 1.20
    ]
]

// First delete albums

eb.send(pa, ['action': 'delete', 'collection': 'albums', 'matcher': [:]]) {

    // Insert albums - in real life price would probably be stored in a different collection, but, hey, this is a demo.

    for (album in albums) {
        eb.send(pa, [
            'action'    : 'save',
            'collection': 'albums',
            'document'  : album
        ])
    }

}

// Delete users

eb.send(pa, ['action': 'delete', 'collection': 'users', 'matcher': [:]]) {

    // Then add a user

    eb.send(pa, [
        'action'    : 'save',
        'collection': 'users',
        'document'  : [
            'firstname': 'Tim',
            'lastname' : 'Fox',
            'email'    : 'tim@localhost.com',
            'username' : 't',
            'password' : 'p'
        ]
    ])
}