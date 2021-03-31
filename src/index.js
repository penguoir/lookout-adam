const express = require('express')
const rss = require('rss')
const rssParser = require('rss-parser')
const urlMetadata = require('url-metadata')
const xml = require('xml')
const url = require('url')

const app = express()
app.get('/', (req, res) => {
  res.send('hi')
})

app.get('/alerts/feeds/:one/:two', async (req, res) => {
  const url = `https://www.google.com/alerts/feeds/${req.params.one}/${req.params.two}`
  const feed = await (new rssParser()).parseURL(url)

  const responseFeed = new rss({
    title: feed.title,
    // TODO: add more
  })

  await Promise.allSettled(
    feed.items.map(async entry => {
      const link = (new URL(entry.link)).searchParams.get('url')
      const data = await urlMetadata(link)

      const getDesc = (data) => {
        const src = data['twitter:image'] || data['og:image']

        if (src) {
          return `<img src="${src}" /> ${data.description}`
        } else {
          return data.description
        }
      }

      responseFeed.item({
        title: data.title || data['og:title'],
        description: getDesc(data),
        url: data.url,
        guid: entry.id,
        date: data.pubDate
          || data.datePublished
          || data['article:published_time']
          || data['twt-published-at']
          || data['DC.date.issued'],
      })
    })
  )

  res.type('text/xml')
  res.send(responseFeed.xml())
})

const PORT = process.env.PORT;
app.listen(PORT, () => {
  console.log(`Started on port ${PORT}`)
})
