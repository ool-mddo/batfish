package org.batfish.representation.cisco;

import org.batfish.datamodel.Configuration;
import org.batfish.datamodel.routing_policy.expr.NamedPrefix6Set;
import org.batfish.datamodel.routing_policy.expr.NamedPrefixSet;
import org.batfish.datamodel.routing_policy.expr.Prefix6SetExpr;
import org.batfish.datamodel.routing_policy.expr.PrefixSetExpr;
import org.batfish.main.Warnings;

public class RoutePolicyPrefixSetName extends RoutePolicyPrefixSet {

   private static final long serialVersionUID = 1L;

   private String _name;

   public RoutePolicyPrefixSetName(String name) {
      _name = name;
   }

   public String getName() {
      return _name;
   }

   @Override
   public Prefix6SetExpr toPrefix6SetExpr(CiscoConfiguration cc,
         Configuration c, Warnings w) {
      if (cc.getPrefixLists().containsKey(_name)) {
         return null;
      }
      else if (!cc.getPrefix6Lists().containsKey(_name)) {
         cc.undefined("Reference to undefined ipv6 prefix-list: " + _name,
               CiscoVendorConfiguration.PREFIX6_LIST, _name);
      }
      else {
         Prefix6List list = cc.getPrefix6Lists().get(_name);
         list.getReferers().put(this,
               "route policy named ipv6 prefix-set: '" + _name + "'");
      }
      return new NamedPrefix6Set(_name);
   }

   @Override
   public PrefixSetExpr toPrefixSetExpr(CiscoConfiguration cc, Configuration c,
         Warnings w) {
      if (cc.getPrefix6Lists().containsKey(_name)) {
         return null;
      }
      else if (!cc.getPrefixLists().containsKey(_name)) {
         cc.undefined("Reference to undefined ipv4 prefix-list: " + _name,
               CiscoVendorConfiguration.PREFIX_LIST, _name);
      }
      else {
         PrefixList list = cc.getPrefixLists().get(_name);
         list.getReferers().put(this,
               "route policy named ipv4 prefix-set: '" + _name + "'");
      }
      return new NamedPrefixSet(_name);
   }

}
