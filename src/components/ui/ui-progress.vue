<template>
  <div class="ui-progress">
  </div>
</template>

<style>
.ui-progress {
  @apply flex m-0 h-1 w-full bg-gray-100 absolute top-0 left-0 right-0 rounded-tl-[inherit] rounded-tr-[inherit];
  &::before {
    border-top-left-radius: inherit;
    border-top-right-radius: inherit;
    @apply flex m-0 h-1 w-full bg-blue-600;
    content: "";
    -webkit-animation: running-progress 1s cubic-bezier(0.4, 0, 0.2, 1)
      infinite;
    animation: running-progress 1s cubic-bezier(0.4, 0, 0.2, 1) infinite;
  }
}

@-webkit-keyframes running-progress  {
  0% {
    margin-left: 0px;
    margin-right: 100%;
  }
  50% {
    margin-left: 25%;
    margin-right: 0%;
  }
  100% {
    margin-left: 100%;
    margin-right: 0;
  }
}

 @keyframes running-progress  {
  0% {
    margin-left: 0px;
    margin-right: 100%;
  }
  50% {
    margin-left: 25%;
    margin-right: 0%;
  }
  100% {
    margin-left: 100%;
    margin-right: 0;
  }
}
</style>
