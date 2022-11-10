# read_news() works with usual format

    {
      "section_df": [
        {
          "line": 1,
          "h2": false,
          "version": "v2.0.0",
          "date": "",
          "nickname": "",
          "original": "# fledge v2.0.0",
          "news": ["* blop", "", "* lala"],
          "raw": "# fledge v2.0.0\n\n* blop\n\n* lala\n"
        },
        {
          "line": 7,
          "h2": false,
          "version": "v1.0.0",
          "date": "",
          "nickname": "",
          "original": "# fledge v1.0.0",
          "news": ["* blip", "", "* lili"],
          "raw": "# fledge v1.0.0\n\n* blip\n\n* lili\n"
        }
      ],
      "preamble": ["# fledge v2.0.0"]
    } 

# read_news() works with other formats

    {
      "section_df": [
        {
          "line": 1,
          "h2": false,
          "version": "v2.0.0",
          "date": "",
          "nickname": "",
          "original": "# Changes in v2.0.0",
          "news": ["* blop", "", "* lala"],
          "raw": "# Changes in v2.0.0\n\n* blop\n\n* lala\n"
        },
        {
          "line": 7,
          "h2": false,
          "version": "v1.0.0",
          "date": "",
          "nickname": "",
          "original": "# Changes in v1.0.0",
          "news": ["* blip", "", "* lili"],
          "raw": "# Changes in v1.0.0\n\n* blip\n\n* lili\n"
        }
      ],
      "preamble": ["# Changes in v2.0.0"]
    } 

# read_news() works with nicknames

    {
      "section_df": [
        {
          "line": 1,
          "h2": false,
          "version": "v2.0.0",
          "date": "",
          "nickname": "\"Vigorous Calisthenics\"",
          "original": "# Changes in v2.0.0 \"Vigorous Calisthenics\"",
          "news": ["* blop", "", "* lala"],
          "raw": "# Changes in v2.0.0 \"Vigorous Calisthenics\"\n\n* blop\n\n* lala\n"
        },
        {
          "line": 7,
          "h2": false,
          "version": "v1.0.0",
          "date": "",
          "nickname": "\"Pumpkin Helmet\"",
          "original": "# Changes in v1.0.0 \"Pumpkin Helmet\"",
          "news": ["* blip", "", "* lili"],
          "raw": "# Changes in v1.0.0 \"Pumpkin Helmet\"\n\n* blip\n\n* lili\n"
        }
      ],
      "preamble": ["# Changes in v2.0.0 \"Vigorous Calisthenics\""]
    } 

# read_news() works with h2

    {
      "section_df": [
        {
          "line": 1,
          "h2": true,
          "version": "v2.0.0",
          "date": "",
          "nickname": "\"Vigorous Calisthenics\"",
          "original": "## Changes in v2.0.0 \"Vigorous Calisthenics\"",
          "news": ["* blop", "", "* lala"],
          "raw": "## Changes in v2.0.0 \"Vigorous Calisthenics\"\n\n* blop\n\n* lala\n"
        },
        {
          "line": 7,
          "h2": true,
          "version": "v1.0.0",
          "date": "",
          "nickname": "\"Pumpkin Helmet\"",
          "original": "## Changes in v1.0.0 \"Pumpkin Helmet\"",
          "news": ["* blip", "", "* lili"],
          "raw": "## Changes in v1.0.0 \"Pumpkin Helmet\"\n\n* blip\n\n* lili\n"
        }
      ],
      "preamble": ["## Changes in v2.0.0 \"Vigorous Calisthenics\""]
    } 

