import React, {useState} from 'react'
import axios from 'axios'

function App() {

  //const url = 'https://api.openweathermap.org/data/2.5/weather?q={Houston}&appid=17f8bf2538d5441807e12800471991d0'
  return (
    <div className="app">
      <div className="container">
        <div className="top">
          <div className="location">
            <p>Houston</p>
          </div>
          <div className="temp">
            <h1>60°F</h1>
          </div>
          <div className="description">
            <p>Clouds</p>
          </div>
        </div>
        <div class name="bottom">
          <div className="feels">
            <p>60°F</p>
          </div>
          <div className='humiditiy'>
            <p>20%</p>
          </div>
        </div>
      </div>
    </div>
  );
}

export default App;
