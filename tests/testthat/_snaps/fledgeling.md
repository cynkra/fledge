# read_news() works with usual format

    [
      {
        "line": 1,
        "h2": false,
        "version": "v2.0.0",
        "date": "",
        "nickname": "",
        "original": "# fledge v2.0.0",
        "news": ["* blop", "", "* lala"]
      },
      {
        "line": 7,
        "h2": false,
        "version": "v1.0.0",
        "date": "",
        "nickname": "",
        "original": "# fledge v1.0.0",
        "news": ["* blip", "", "* lili"]
      }
    ] 

# read_news() works with other formats

    [
      {
        "line": 1,
        "h2": false,
        "version": "v2.0.0",
        "date": "",
        "nickname": "",
        "original": "# Changes in v2.0.0",
        "news": ["* blop", "", "* lala"]
      },
      {
        "line": 7,
        "h2": false,
        "version": "v1.0.0",
        "date": "",
        "nickname": "",
        "original": "# Changes in v1.0.0",
        "news": ["* blip", "", "* lili"]
      }
    ] 

# read_news() works with nicknames

    [
      {
        "line": 1,
        "h2": false,
        "version": "v2.0.0",
        "date": "",
        "nickname": "\"Vigorous Calisthenics\"",
        "original": "# Changes in v2.0.0 \"Vigorous Calisthenics\"",
        "news": ["* blop", "", "* lala"]
      },
      {
        "line": 7,
        "h2": false,
        "version": "v1.0.0",
        "date": "",
        "nickname": "\"Pumpkin Helmet\"",
        "original": "# Changes in v1.0.0 \"Pumpkin Helmet\"",
        "news": ["* blip", "", "* lili"]
      }
    ] 

# read_news() works with h2

    [
      {
        "line": 1,
        "h2": true,
        "version": "v2.0.0",
        "date": "",
        "nickname": "\"Vigorous Calisthenics\"",
        "original": "## Changes in v2.0.0 \"Vigorous Calisthenics\"",
        "news": ["* blop", "", "* lala"]
      },
      {
        "line": 7,
        "h2": true,
        "version": "v1.0.0",
        "date": "",
        "nickname": "\"Pumpkin Helmet\"",
        "original": "## Changes in v1.0.0 \"Pumpkin Helmet\"",
        "news": ["* blip", "", "* lili"]
      }
    ] 

