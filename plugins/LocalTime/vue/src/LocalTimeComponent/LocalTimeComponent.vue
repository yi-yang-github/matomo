<!--
  Matomo - free/libre analytics platform

  @link https://matomo.org
  @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
-->

<template>
  <div class="local-time-component widgetContent">
    1111
    {{ localTime }}
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
import moment from 'moment';

// interface ExampleComponentState {
//   count: number;
//   showDialog: boolean;
// }

export default defineComponent({
  components: {
    LocalTimeComponent,
  },

  methods: {
    utcTime() {
      const date = moment.utc().format('MM/DD/YYYY HH:mm z');
      return date;
    },
    localTime() {
      const date = this.utcTime();
      const local = moment.utc(date).local().format('MM/DD/YYYY HH:mm z');
      return local;
    },


  },
});
</script>
