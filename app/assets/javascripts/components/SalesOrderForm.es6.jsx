var SalesOrderForm = React.createClass({
  getInitialState: function() {
    return {
      orderNumber: '',
      locations: [],
      shipFromLocations: [],
      customer: {},
      disableLocationSelectField: true,
      clicked: false,
      shipToLocation: {},
      billToLocation: {},
      shipFromLocation: {},
      items: [],
      shippedOn: '2016-08-31'
    }
  },
  componentDidMount: function() {
    this.loadShipFromLocationsFromServer();
  },
  defaultShippedOn: function() {
    return this.state.shippedOn;
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var inputData = {
      orderNumber:      this.state.orderNumber.trim(),
      customer:         this.state.customer,
      shipToLocation:   this.state.shipToLocation,
      billToLocation:   this.state.billToLocation,
      shipFromLocation: this.state.shipFromLocation,
      shippedOn:        this.state.shippedOn,
      items:            this.state.items,
    };

    // Check input values
    if (_.isEmpty(inputData.orderNumber))      {return;}
    if (_.isEmpty(inputData.customer))         {return;}
    if (_.isEmpty(inputData.shipToLocation))   {return;}
    if (_.isEmpty(inputData.billToLocation))   {return;}
    if (_.isEmpty(inputData.shipFromLocation)) {return;}
    if (_.isEmpty(inputData.shippedOn))        {return;}
    if (_.isEmpty(inputData.items))            {return;}
    for (var i = 0; i < inputData.items.length; i++) {
      if (_.isEmpty(inputData.items[i].unitPrice))    {return;}
      if (_.isEmpty(inputData.items[i].quantity)) {return;}
    }

    // POST to server
    $.ajax({
      url: '/api/v1/sales_orders',
      dataType: 'json',
      type: 'POST',
      data: inputData,
      success: function(data) {
        window.location.href = '/sales_orders/' + data.sales_order.id;
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },
  handleCustomerChange: function(customer) {
    this.setState({
      customer: customer,
      disableLocationSelectField: false
    });
    $.ajax({
      url: "/api/v1/customers/" + customer.id + "/locations",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({locations: data.locations});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  handleOrderNumberChange: function(orderNumber) {
    this.setState({orderNumber: orderNumber})
  },
  loadShipFromLocationsFromServer: function() {
    $.ajax({
      url: "/api/v1/locations",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({shipFromLocations: data.locations});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  handleShipToLocationChange: function(location) {
    this.setState({shipToLocation: {id: location.id}});
  },
  handleReceiptLocationChange: function(location) {
    this.setState({billToLocation: {id: location.id}});
  },
  handleShipFromLocationChange: function(location) {
    this.setState({shipFromLocation: {id: location.id}});
  },
  handleDateChange: function(dateString) {
    this.setState({shippedOn: dateString});
  },
  handleDynamicItemFieldListChange: function(items) {
    this.setState({items: items});
  },
  render: function() {
    return(
      <form className="salesOrderForm" onSubmit={this.handleSubmit}>
        <div>
          <label>出貨單單號</label>
          <OrderNumberField
            nextValidOrderNumberUrl="/api/v1/sales_orders/next_number"
            onOrderNumberChange={this.handleOrderNumberChange}
          />
        </div>
        <br />
        <div>
          <label>收貨客戶</label>
          <CustomersSelectField
            customersUrl='/api/v1/customers'
            onCustomerChange={this.handleCustomerChange}
          />
        </div>
        <br />
        <div>
          <label>寄貨至：</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleShipToLocationChange}
          />
        </div>
        <br />
        <div>
          <label>寄發票至：</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleReceiptLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨地點</label>
          <LocationsSelectField
            disabled={false}
            locations={this.state.shipFromLocations}
            onLocationChange={this.handleShipFromLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨日期</label>
          <DateField defaultValue={this.defaultShippedOn()} onDateChange={this.handleDateChange} />
        </div>
        <br />
        <DynamicItemFieldList onDynamicItemFieldListChange={this.handleDynamicItemFieldListChange} />
        <br />
        <div>
          <input type="submit" value="建立出貨單" />
        </div>
      </form>
    );
  }
});
