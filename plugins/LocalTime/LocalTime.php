<?php
/**
 * Matomo - free/libre analytics platform
 *
 * @link https://matomo.org
 * @license http://www.gnu.org/licenses/gpl-3.0.html GPL v3 or later
 */

namespace Piwik\Plugins\LocalTime;

class LocalTime extends \Piwik\Plugin
{
    public function registerEvents()
    {
        return [
            'AssetManager.getJavaScriptFiles' => 'getJavaScriptFiles',
            'CronArchive.getArchivingAPIMethodForPlugin' => 'getArchivingAPIMethodForPlugin',
        ];
    }

    public function getJavaScriptFiles(&$files)
    {
        $files[] = "plugins/LocalTime/javascripts/localtime.js";
    }


    // support archiving just this plugin via core:archive
    public function getArchivingAPIMethodForPlugin(&$method, $plugin)
    {
        if ($plugin == 'LocalTime') {
            $method = 'LocalTime.getExampleArchivedMetric';
        }
    }
}
