const express = require("express")
const axios = require("axios")

const app = express()
const { OMDB_API_KEY } = process.env;

app.use(express.json())
app.post("/", async (req, res) => {
  // express에 json플러그인을 등록했기 때문에 JSON.parse를 사용할 필요가 없다.
  const payload = req.body;
  const { title, type, year, page, id } = payload;

  console.log("OMDB_API_KEY: ", OMDB_API_KEY);
  console.log("params: ", payload);

  const url = id
    ? `https://www.omdbapi.com/?apikey=${OMDB_API_KEY}&i=${id}&plot=full`
    : `https://www.omdbapi.com/?apikey=${OMDB_API_KEY}&s=${title}&type=${type}&y=${year}&page=${page}`;

  try {
    const { data } = await axios.get(url);
    if (data.Error) {
      res.status(400)
      .json(data.Error);
    }

    //console.log(JSON.stringify(data))

    res.status(200)
    .json(data);
  } catch (error) {
    res.status(error.response.status)
    .json(error.message);
  }
});

module.exports = app;
