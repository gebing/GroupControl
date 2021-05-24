#!/usr/bin/env python
#coding=utf-8

import sys
from genpac import formater, FmtBase, GenPAC

@formater('gost')
class FmtGost(FmtBase):
  _default_tpl = '''
#! __GENPAC__
#! Generated: __GENERATED__
#! GFWList: __GFWLIST_DETAIL__

# options
#reload 10s
reverse __REVERSE__
# bypass domains
__DIRECT_RULES__
# proxy domains
__GFWED_RULES__
'''

  def __init__(self, *args, **kwargs):
    super(FmtGost, self).__init__(*args, **kwargs)

  @classmethod
  def arguments(cls, parser):
    group = parser.add_argument_group(title=cls._name.upper(), description='基于Gost的代理转发程序的配置')
    group.add_argument('--bypass', action='store_true', default=False, help='生成忽略代理的域名列表，缺省生成使用代理的域名列表')

  @classmethod
  def config(cls, options):
    options['bypass'] = {}

  def generate(self, replacements):
    direct_rules = [('.' + r) for r in (self.ignored_domains if self.options.bypass else [])]
    gfwed_rules = [('.' + r) for r in (self.gfwed_domains if not self.options.bypass else [])]
    replacements.update({
      '__REVERSE__': 'true' if not self.options.bypass else 'false',
      '__DIRECT_RULES__': '\n'.join(direct_rules),
      '__GFWED_RULES__': '\n'.join(gfwed_rules)
    })
    return self.replace(self.tpl, replacements)

def main():
  try:
    gp = GenPAC()
    gp.run()
  except Exception as e:
    genpac.util.exit_error(e)

if __name__ == '__main__':
  main()
