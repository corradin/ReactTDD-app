import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import { shallow, mount } from 'enzyme';

import ShallowRenderer from 'react-test-renderer/shallow'; // ES6

import renderer from 'react-test-renderer';

it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
  expect(ReactDOM.unmountComponentAtNode(div)).toEqual(true);
});

// it('should match the snapshot', () => {
//   const div = document.createElement('div');
//   ReactDOM.render(<App />, div);
//   expect(div).toMatchSnapshot();
//   ReactDOM.unmountComponentAtNode(div);
// });

//Use this instead of ReactDOM?
// it('renders without crashing', () => {
//   mount(<App />);
// });

it('should match the snapshot', () => {
  const component = renderer.create(
    <App />
  );
  let tree = component.toJSON();
  expect(tree).toMatchSnapshot();
});

it('should render the button correctly', () => {
  const wrapper = mount(<App />);
  const buttonText = 'Press';
  expect(wrapper.contains(buttonText)).toEqual(true);
});