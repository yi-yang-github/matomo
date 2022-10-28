/*!
 * Matomo - free/libre analytics platform
 *
 * @link https://matomo.org
 * @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 */

import { defineAsyncComponent } from 'vue';
import { createAngularJsAdapter } from 'CoreHome';

const LocalTimeComponent = defineAsyncComponent(() => import('./LocalTimeComponent.vue'));

export default createAngularJsAdapter({
  component: LocalTimeComponent,
  directiveName: 'localTimeComponent',
});
