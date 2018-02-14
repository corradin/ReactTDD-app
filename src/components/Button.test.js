import React from 'react';
import Button from './Button';
import { shallow } from 'enzyme';
import renderer from 'react-test-renderer';

it('should render without crashing', () => {
    shallow(<Button />);
});

it('should match the snapshot', () => {
    const component = renderer.create(
        <Button />
      );
      let tree = component.toJSON();
      expect(tree).toMatchSnapshot();
  });

it('should display the correct text', () => {
    const wrapper = shallow(<Button text="Hit me"/>);
    const buttonText = 'Hit me';
    expect(wrapper.contains(buttonText)).toEqual(true);
});