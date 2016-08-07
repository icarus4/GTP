var CustomersSelectField = React.createClass({
  getInitialState: function() {
    return {customers: [], selectedCustumerId: 0};
  },
  loadCustomersFromServer: function() {
    $.ajax({
      url: this.props.customersUrl,
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({customers: data.customers});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, error.toString());
      }.bind(this)
    });
  },
  componentDidMount: function() {
    this.loadCustomersFromServer();
  },
  handleCustomerChange: function(e) {
    this.setState({selectedCustumerId: e.target.value});
    this.props.onCustomerChange({id: e.target.value});
  },
  render: function() {
    var optionNodes = this.state.customers.map(function(customer) {
      return (
        <option key={customer.id} value={customer.id}>{customer.name}</option>
      );
    });
    return (
      <select value={this.state.selectedCustumerId} onChange={this.handleCustomerChange}>
        <option key="0" value="0" disabled> -- 選取客戶 -- </option>
        {optionNodes}
      </select>
    );
  }
});
