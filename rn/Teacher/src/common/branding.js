//
// Copyright (C) 2017-present Instructure, Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 3 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

// @flow

import { StyleSheet } from 'react-native'
import color, { isDark } from '../common/colors'

export type BrandingConfiguration = {
  link: string,
  navBarColor: string,
  navBarButtonColor: string,
  navBarTextColor: string,
  primaryButtonColor: string,
  primaryButtonTextColor: string,
  primaryBrandColor: string,
  fontColorDark: string,
  headerImage?: any,
}

export const branding: BrandingConfiguration = {
  link: color.link,
  navBarColor: color.navBarColor,
  navBarButtonColor: color.primaryButtonText,
  navBarTextColor: color.primaryButtonText,
  primaryButtonTextColor: color.primaryButtonText,
  primaryButtonColor: color.primaryButton,
  fontColorDark: '#000',
  headerImage: require('../images/canvas-logo.png'),
  primaryBrandColor: color.navBarColor,
}

const updates = []
export function setupBrandingFromNativeBrandingInfo (obj: Object): void {
  branding.link = obj[`ic-link-color`] || branding.link
  branding.navBarColor = obj[`ic-brand-global-nav-bgd`] || branding.navBarColor
  branding.primaryButtonTextColor = obj[`ic-brand-button--primary-text`] || branding.primaryButtonTextColor
  branding.primaryButtonColor = obj[`ic-brand-button--primary-bgd`] || branding.primaryButtonColor
  branding.fontColorDark = obj[`ic-brand-font-color-dark`] || branding.fontColorDark
  branding.navBarButtonColor = obj[`ic-brand-global-nav-ic-icon-svg-fill`] || branding.navBarButtonColor
  branding.navBarTextColor = obj[`ic-brand-global-nav-menu-item__text-color`] || branding.navBarTextColor
  branding.primaryBrandColor = obj[`ic-brand-primary`] || branding.primaryBrandColor
  branding.headerImage = obj[`ic-brand-header-image`] || branding.headerImage

  //  now that we have branding data, set colors object as well
  color.link = branding.link
  color.navBarColor = branding.navBarColor
  color.navBarButtonColor = branding.navBarButtonColor
  color.navBarTextColor = branding.navBarTextColor
  color.primaryButtonTextColor = branding.primaryButtonTextColor
  color.primaryButtonColor = branding.primaryButtonColor
  color.primaryBrandColor = branding.primaryBrandColor
  color.statusBarStyle = isDark(color.navBarColor) ? 'light' : 'default'

  // update style sheets
  for (const update of updates) update(color)
}

type Styles = {[string]: Object}
export function createStyleSheet<S: Styles> (factory: (typeof color) => S) {
  const sheet = StyleSheet.create(factory(color))
  updates.push(color => Object.assign(sheet, StyleSheet.create(factory(color))))
  return sheet
}

export default branding
