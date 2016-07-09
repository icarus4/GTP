var OrderNumberField = React.createClass({
  getInitialState: function() {
    return {order_number: ''}
  },
  handleOrderNumberChange: function(e) {
    this.setState({order_number: e.target.value});
    this.props.onOrderNumberChange(e.target.value);
  },
  loadOrderNumberFromServer: function() {
    $.ajax({
      url: this.props.nextValidOrderNumberUrl,
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({order_number: data.next_number});
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

var CustomersSelectField = React.createClass({
  getInitialState: function() {
    return {customers: []}
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
    this.props.onCustomerChange({id: e.target.value});
  },
  render: function() {
    var optionNodes = this.state.customers.map(function(customer) {
      return (
        <option key={customer.id} value={customer.id}>{customer.name}</option>
      );
    });
    return (
      <select value="0" onChange={this.handleCustomerChange}>
        <option value="0" disabled> -- 選取客戶 -- </option>
        {optionNodes}
      </select>
    );
  }
});

var LocationsSelectField = React.createClass({
  onLocationChange: function() {
    // this.prop.onLocationChange
  },
  render: function() {
    var optionNodes = this.props.locations.map(function(location) {
      return (
        <option key={location.id} value={location.id}>{location.name}</option>
      );
    });
    return (
      <select disabled={this.props.disabled}>
        {optionNodes}
      </select>
    );
  }
});

var DateField = React.createClass({
  getInitialState: function() {
    return {date: "2016-08-01"};
  },
  handleDateChange: function(e) {
    this.setState({date: e.target.value});
  },
  render: function() {
    return(
      <input value={this.state.date} type="date" onChange={this.handleDateChange} />
    );
  }
});

var ItemField = React.createClass({
  render: function() {
    var optionNodes = this.props.items.map(function(item) {
      return (
        <option key={item.id} value={item.id}>{item.name}</option>
      )
    })
    return(
      <div>
        {this.props.label ? (<label>{this.props.label}</label>) : null}
        <select>
          {optionNodes}
        </select>
        <label>Qty</label><input type="number" min="1" style={{width: '60px'}} />
        <label>price</label><input type="number" min="0" style={{width: '100px'}} />
      </div>
    )
  }
});

var DynamicItemFieldList = React.createClass({
  getInitialState: function() {
    return {
      maxItemFieldId: 0,
      itemFields: [{id: 0}],
      items: [],
    };
  },
  loadItemsFromServer: function() {
    $.ajax({
      url: "/api/v1/items",
      dataType: 'json',
      type: 'GET',
      cache: false,
      success: function(data) {
        this.setState({items: data.items});
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(status, err.toString());
      }.bind(this)
    });
  },
  componentWillMount: function() {
    this.loadItemsFromServer();
  },
  handleClickAddItemButton: function() {
    var itemFields = this.state.itemFields;
    var nextItemFieldId = this.state.maxItemFieldId + 1;
    itemFields.push({id: nextItemFieldId});
    this.setState({maxItemFieldId: nextItemFieldId});
  },
  handleClickRemoveButton: function(id) {
    var itemFields = this.state.itemFields;
    for (var i = 0; i < itemFields.length; i++) {
      if (itemFields[i].id == id) {
        itemFields.splice(i, 1);
        break;
      }
    }
    this.setState({itemFields: itemFields});
  },
  render: function() {
    var items = this.state.items;
    var handleClickRemoveButton = this.handleClickRemoveButton;
    var itemFieldNodes = this.state.itemFields.map(function(itemField) {
      return (
        <div key={"item-field-" + itemField.id}>
          <ItemField key={itemField.id} items={items} label="選擇貨品" />
          <button
            key={"remove-button-" + itemField.id}
            type="button"
            className="btn btn-default btn-xs"
            onClick={handleClickRemoveButton.bind(null, itemField.id)}>
            x
          </button>
        </div>
      );
    });
    return (
      <div id="itemList">
        {itemFieldNodes}
        <br />
        <span className="label label-primary" onClick={this.handleClickAddItemButton}>+貨品</span>
      </div>
    );
  }
});

var SalesOrderForm = React.createClass({
  getInitialState: function() {
    return {
      orderNumber: '',
      locations: [],
      shipFromLocations: [],
      customer: {},
      disableLocationSelectField: true,
      clicked: false
    }
  },
  handleSubmit: function(e) {
    e.preventDefault();
    var orderNumber = this.state.orderNumber;
    if (!orderNumber) {
      return;
    }
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
  componentDidMount: function() {
    this.loadShipFromLocationsFromServer();
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
          <label>寄貨地點</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleLocationChange}
          />
        </div>
        <br />
        <div>
          <label>寄發票地點</label>
          <LocationsSelectField
            disabled={this.state.disableLocationSelectField}
            locations={this.state.locations}
            onLocationChange={this.handleLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨地點</label>
          <LocationsSelectField
            disabled={false}
            locations={this.state.shipFromLocations}
            onLocationChange={this.handleLocationChange}
          />
        </div>
        <br />
        <div>
          <label>出貨日期</label>
          <DateField />
        </div>
        <br />
        <DynamicItemFieldList />
      </form>
    );
  }
});
