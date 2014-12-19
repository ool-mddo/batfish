package batfish.representation.juniper;

import batfish.representation.PolicyMapSetLine;

public final class ThenCommunitySet extends Then {

   /**
    *
    */
   private static final long serialVersionUID = 1L;

   private final String _name;

   public ThenCommunitySet(String name) {
      _name = name;
   }

   public String getName() {
      return _name;
   }

   @Override
   public PolicyMapSetLine toPolicyStatmentSetLine() {
      // TODO Auto-generated method stub
      return null;
   }

}
