import Base from './base';

export default Base.extend({
  init() {
    _.defaults(this.defaultQueryParams, {
      interval: 'day',
    });
  },

  model(params) {
    this._super(params);
    if(this.validateOptions()) {
      return Admin.StatsLogs.find(this.get('query.params'));
    } else {
      return {};
    }
  },

  queryChange: function() {
    let newQueryParams = this.get('query.params');
    if(newQueryParams && !_.isEmpty(newQueryParams)) {
      let activeQueryParams = this.get('activeQueryParams');
      if(!_.isEqual(newQueryParams, activeQueryParams)) {
        this.transitionTo('stats.logs', $.param(newQueryParams));
      }
    }
  }.observes('query.params.query', 'query.params.search', 'query.params.interval', 'query.params.start_at', 'query.params.end_at', 'query.params.beta_analytics'),

  validateOptions() {
    let valid = true;

    let interval = this.get('query.params.interval');
    let start = moment(this.get('query.params.start_at'));
    let end = moment(this.get('query.params.end_at'));

    let range = end.unix() - start.unix();
    switch(interval) {
      case 'minute':
        // 2 days maximum range
        if(range > 2 * 24 * 60 * 60) {
          valid = false;
          bootbox.alert('Your date range is too large for viewing minutely data. Adjust your viewing interval or choose a date range to no more than 2 days.');
        }

        break;
      case 'hour':
        // 31 day maximum range
        if(range > 31 * 24 * 60 * 60) {
          valid = false;
          bootbox.alert('Your date range is too large for viewing hourly data. Adjust your viewing interval or choose a date range to no more than 31 days.');
        }

        break;
    }

    return valid;
  },
});
