var DateField = React.createClass({
  getInitialState: function() {
    return {date: this.props.defaultValue};
  },
  handleDateChange: function(e) {
    this.setState({date: e.target.value});
    this.props.onDateChange(e.target.value);
  },
  render: function() {
    return(
      <input value={this.state.date} type="date" onChange={this.handleDateChange} />
    );
  }
});
