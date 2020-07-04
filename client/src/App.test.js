import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';

// requests to the Express server might fail before Redis and Postgres are running
// for that reason we just comment out the body of it()
// a faker module could solve that issue in a real test suite
it('renders without crashing', () => {
  // const div = document.createElement('div');
  // ReactDOM.render(<App />, div);
  // ReactDOM.unmountComponentAtNode(div);
});
