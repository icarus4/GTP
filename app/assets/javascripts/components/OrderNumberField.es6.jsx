var OrderNumberField = React.createClass({
  getInitialState: function() {
    return {order_number: ''}
  },
  changeOrderNumber: function(orderNumber) {
    this.setState({order_number: orderNumber});
    this.props.onOrderNumberChange(orderNumber);
  },
  handleOrderNumberChange: function(e) {
    this.changeOrderNumber(e.target.value);
  },
  loadOrderNumberFromServer: function() {
    $.ajax({
      url: this.props.nextValidOrderNumberUrl,
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.changeOrderNumber(data.next_number);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, error.toString());
      }.bind(this)
    });
  },
  componentDidMount: function() {
    this.loadOrderNumberFromServer();
  },
  render: function() {
    return (
      <input
        type="text"
        placeholder="出貨單號"
        value={this.state.order_number}
        onChange={this.handleOrderNumberChange}
      />
    )
  }
});
