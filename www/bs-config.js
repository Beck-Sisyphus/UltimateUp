var files = [
    "!(*.html)",
    "css/**/**.css",
    "assets/**/*"
    ];

module.exports = {
    "ui": false,
    "files": files,
    "watchOptions": {},
    "server": true,
    "proxy": false,
    "port": 3000,
    "ghostMode": false,
    "logLevel": "info",
    "logPrefix": "BS",
    "logFileChanges": true,
    "logSnippet": true,
    "open": false,
    "reloadOnRestart": true,
    "notify": true,
    "reloadDelay": 0,
    "reloadDebounce": 100,
    "plugins": [
        {
            "module": "bs-html-injector",
            "options":
            {
                "files": "*.html"
            }
        }
    ],
    "injectChanges": true,
    "minify": true,
    "host": null,
    "codeSync": true,
    "tagNames": {
        "less": "link",
        "scss": "link",
        "css": "link",
        "jpg": "img",
        "jpeg": "img",
        "png": "img",
        "svg": "img",
        "gif": "img",
        "js": "script"
    }
};
