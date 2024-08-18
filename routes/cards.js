"use strict";

/** Routes for companies. */ 
const express = require("express");
const axios = require('axios');

const { BadRequestError } = require("../expressError");

const router = new express.Router();

const { apiKey } = require("../config");

/** GET /:page  =>
 *   returns all cards on a page
 */
router.get("/:page", async function (req, res, next) {
  const page = req.params.page;
    try {
        const response = await axios.get(`https://api.pokemontcg.io/v2/cards/`, {
            headers: {
              'X-Api-Key': apiKey
            },
            params: {
                pageSize: 100,
                page: page
            }

        });
        return res.json(response.data);
      } catch (error) {
        return next(error);
      }
});


// Route to get a card by ID
router.get('/id/:id', async (req, res, next) => {
    const cardId = req.params.id;
    try {
      const response = await axios.get(`https://api.pokemontcg.io/v2/cards/${cardId}`, {
        headers: {
          'X-Api-Key': apiKey
        }
      });
      const card = response.data;
      return res.json(card);
    } catch (error) {
      return next(error)
    }
});

// Route to get a list of cards by name
router.get('/name/:name', async (req, res, next) => {
    const name  = req.params.name;
    try {
      const response = await axios.get(`https://api.pokemontcg.io/v2/cards`, {
        headers: {
          'X-Api-Key': apiKey
        },
        params: {
            q: `name:${name}`
        }
      });
      const cards = response.data;
      return res.json(cards);
    } catch (error) {
      return next(error)
    }
});

// Route to get a batch of cards by ID
//requires a list of ids passed in the body
router.post('/batch', async (req, res, next) => {
  const cardIds = req.body.cards;
  console.log(cardIds);
  try {
    const requests = cardIds.map( id =>  axios.get(`https://api.pokemontcg.io/v2/cards/${id}`, {
      headers: {
        'X-Api-Key': apiKey // Send the API key in the headers
      }
    }));
    const responses = await axios.all(requests);
    const cards = responses.map(response => response.data);
    res.json(cards);
  } catch (error) {
    console.error('Error fetching cards:', error);
    throw error;
  }
});


module.exports = router;

