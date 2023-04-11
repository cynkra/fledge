# read_news() works with usual format

    {
      "section_df": [
        {
          "start": 3,
          "end": 8,
          "h2": false,
          "raw": "# fledge v2.0.0\n\n* blop\n\n* lala\n",
          "news": {
            "Uncategorized": ["- blop", "", "- lala"]
          },
          "section_state": "keep",
          "title": "fledge v2.0.0",
          "version": "2.0.0",
          "date": "NA",
          "nickname": "NA"
        },
        {
          "start": 9,
          "end": 14,
          "h2": false,
          "raw": "# fledge v1.0.0\n\n* blip\n\n* lili\n",
          "news": {
            "Uncategorized": ["- blip", "", "- lili"]
          },
          "section_state": "keep",
          "title": "fledge v1.0.0",
          "version": "1.0.0",
          "date": "NA",
          "nickname": "NA"
        }
      ],
      "preamble": ["<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"],
      "preamble_in_file": [true]
    } 

# read_news() works with other formats

    {
      "section_df": [
        {
          "start": 3,
          "end": 9,
          "h2": false,
          "raw": "# Changes in v2.0.0\n\n* blop\n\n* lala\n\n",
          "news": {
            "Uncategorized": ["- blop", "", "- lala"]
          },
          "section_state": "keep",
          "title": "Changes in v2.0.0",
          "version": "2.0.0",
          "date": "NA",
          "nickname": "NA"
        },
        {
          "start": 10,
          "end": 15,
          "h2": false,
          "raw": "# Changes in v1.0.0\n\n* blip\n\n* lili\n",
          "news": {
            "Uncategorized": ["- blip", "", "- lili"]
          },
          "section_state": "keep",
          "title": "Changes in v1.0.0",
          "version": "1.0.0",
          "date": "NA",
          "nickname": "NA"
        }
      ],
      "preamble": ["<!-- Hands off, please -->"],
      "preamble_in_file": [true]
    } 

# read_news() works with nicknames

    {
      "section_df": [
        {
          "start": 3,
          "end": 8,
          "h2": false,
          "raw": "# Changes in v2.0.0 \"Vigorous Calisthenics\"\n\n* blop\n\n* lala\n",
          "news": {
            "Uncategorized": ["- blop", "", "- lala"]
          },
          "section_state": "keep",
          "title": "Changes in v2.0.0 \"Vigorous Calisthenics\"",
          "version": "2.0.0",
          "date": "NA",
          "nickname": "\"Vigorous Calisthenics\""
        },
        {
          "start": 9,
          "end": 14,
          "h2": false,
          "raw": "# Changes in v1.0.0 \"Pumpkin Helmet\"\n\n* blip\n\n* lili\n",
          "news": {
            "Uncategorized": ["- blip", "", "- lili"]
          },
          "section_state": "keep",
          "title": "Changes in v1.0.0 \"Pumpkin Helmet\"",
          "version": "1.0.0",
          "date": "NA",
          "nickname": "\"Pumpkin Helmet\""
        }
      ],
      "preamble": ["<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"],
      "preamble_in_file": [true]
    } 

# read_news() works with h2

    {
      "section_df": [
        {
          "start": 3,
          "end": 8,
          "h2": true,
          "raw": "## Changes in v2.0.0 \"Vigorous Calisthenics\"\n\n* blop\n\n* lala\n",
          "news": {
            "Uncategorized": ["- blop", "", "- lala"]
          },
          "section_state": "keep",
          "title": "Changes in v2.0.0 \"Vigorous Calisthenics\"",
          "version": "2.0.0",
          "date": "NA",
          "nickname": "\"Vigorous Calisthenics\""
        },
        {
          "start": 9,
          "end": 14,
          "h2": true,
          "raw": "## Changes in v1.0.0 \"Pumpkin Helmet\"\n\n* blip\n\n* lili\n",
          "news": {
            "Uncategorized": ["- blip", "", "- lili"]
          },
          "section_state": "keep",
          "title": "Changes in v1.0.0 \"Pumpkin Helmet\"",
          "version": "1.0.0",
          "date": "NA",
          "nickname": "\"Pumpkin Helmet\""
        }
      ],
      "preamble": ["<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"],
      "preamble_in_file": [true]
    } 

# read_news() works with two-lines headers

    {
      "section_df": [
        {
          "start": 1,
          "end": 7,
          "h2": false,
          "raw": "fledge v2.0.0\n=============\n\n* blop\n\n* lala\n",
          "news": {
            "Uncategorized": ["- blop", "", "- lala"]
          },
          "section_state": "keep",
          "title": "fledge v2.0.0",
          "version": "2.0.0",
          "date": "NA",
          "nickname": "NA"
        },
        {
          "start": 8,
          "end": 13,
          "h2": false,
          "raw": "# fledge v1.0.0\n\n* blip\n\n* lili\n",
          "news": {
            "Uncategorized": ["- blip", "", "- lili"]
          },
          "section_state": "keep",
          "title": "fledge v1.0.0",
          "version": "1.0.0",
          "date": "NA",
          "nickname": "NA"
        }
      ],
      "preamble": ["<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->"],
      "preamble_in_file": [false]
    } 

